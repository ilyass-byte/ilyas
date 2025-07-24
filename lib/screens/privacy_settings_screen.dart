import 'package:flutter/material.dart';
import '../core/language.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  // Privacy settings state
  bool _privacyModeEnabled = false;
  bool _hideTaskContent = false;
  bool _blurSensitiveData = false;
  bool _hideNotificationContent = false;
  bool _incognitoMode = false;
  bool _analyticsOptOut = true;
  bool _locationTrackingDisabled = true;
  bool _hideFromRecents = false;
  bool _screenshotProtection = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Container(
          margin: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF9C27B0), Color(0xFFE91E63)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF9C27B0).withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Text(
          AppLocalizations.translate('privacy_settings'),
          style: const TextStyle(
            color: Color(0xFF2D3748),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Privacy Mode Header
              AnimatedBuilder(
                animation: _slideAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _slideAnimation.value),
                    child: _buildPrivacyHeader(),
                  );
                },
              ),

              const SizedBox(height: 32),

              // Privacy Controls
              AnimatedBuilder(
                animation: _slideAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _slideAnimation.value * 1.5),
                    child: _buildPrivacyControls(),
                  );
                },
              ),

              const SizedBox(height: 24),

              // Data Protection
              AnimatedBuilder(
                animation: _slideAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _slideAnimation.value * 2),
                    child: _buildDataProtection(),
                  );
                },
              ),

              const SizedBox(height: 24),

              // App Security
              AnimatedBuilder(
                animation: _slideAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _slideAnimation.value * 2.5),
                    child: _buildAppSecurity(),
                  );
                },
              ),

              const SizedBox(height: 32),

              // Privacy Actions
              AnimatedBuilder(
                animation: _slideAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _slideAnimation.value * 3),
                    child: _buildPrivacyActions(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrivacyHeader() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF9C27B0).withValues(alpha: 0.1),
            const Color(0xFFE91E63).withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF9C27B0).withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF9C27B0), Color(0xFFE91E63)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.privacy_tip_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Privacy Mode',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Protect your sensitive information',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _privacyModeEnabled,
                onChanged: (value) {
                  setState(() {
                    _privacyModeEnabled = value;
                    if (value) {
                      _showPrivacyModeDialog();
                    }
                  });
                },
                activeColor: const Color(0xFF9C27B0),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyControls() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Content Privacy'),
        const SizedBox(height: 16),
        _buildPrivacyCard(
          icon: Icons.visibility_off_rounded,
          title: 'Hide Task Content',
          subtitle: 'Hide task titles and descriptions in overview',
          value: _hideTaskContent,
          onChanged: (value) {
            setState(() {
              _hideTaskContent = value;
            });
          },
          color: const Color(0xFF9C27B0),
        ),
        const SizedBox(height: 16),
        _buildPrivacyCard(
          icon: Icons.blur_on_rounded,
          title: 'Blur Sensitive Data',
          subtitle: 'Blur sensitive information when app is in background',
          value: _blurSensitiveData,
          onChanged: (value) {
            setState(() {
              _blurSensitiveData = value;
            });
          },
          color: const Color(0xFFE91E63),
        ),
        const SizedBox(height: 16),
        _buildPrivacyCard(
          icon: Icons.notifications_off_rounded,
          title: 'Hide Notification Content',
          subtitle: 'Show only generic notification messages',
          value: _hideNotificationContent,
          onChanged: (value) {
            setState(() {
              _hideNotificationContent = value;
            });
          },
          color: const Color(0xFF673AB7),
        ),
      ],
    );
  }

  Widget _buildDataProtection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Data Protection'),
        const SizedBox(height: 16),
        _buildPrivacyCard(
          icon: Icons.analytics_outlined,
          title: 'Disable Analytics',
          subtitle: 'Opt out of usage analytics and data collection',
          value: _analyticsOptOut,
          onChanged: (value) {
            setState(() {
              _analyticsOptOut = value;
            });
          },
          color: const Color(0xFF4CAF50),
        ),
        const SizedBox(height: 16),
        _buildPrivacyCard(
          icon: Icons.location_off_rounded,
          title: 'Disable Location Tracking',
          subtitle: 'Prevent location-based features and tracking',
          value: _locationTrackingDisabled,
          onChanged: (value) {
            setState(() {
              _locationTrackingDisabled = value;
            });
          },
          color: const Color(0xFF2196F3),
        ),
      ],
    );
  }

  Widget _buildAppSecurity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('App Security'),
        const SizedBox(height: 16),
        _buildPrivacyCard(
          icon: Icons.recent_actors_rounded,
          title: 'Hide from Recent Apps',
          subtitle: 'Hide app content from recent apps screen',
          value: _hideFromRecents,
          onChanged: (value) {
            setState(() {
              _hideFromRecents = value;
            });
          },
          color: const Color(0xFFFF9800),
        ),
        const SizedBox(height: 16),
        _buildPrivacyCard(
          icon: Icons.screenshot_rounded,
          title: 'Screenshot Protection',
          subtitle: 'Prevent screenshots and screen recording',
          value: _screenshotProtection,
          onChanged: (value) {
            setState(() {
              _screenshotProtection = value;
            });
          },
          color: const Color(0xFFE91E63),
        ),
        const SizedBox(height: 16),
        _buildPrivacyCard(
          icon: Icons.visibility_off_rounded,
          title: 'Incognito Mode',
          subtitle: 'Browse without saving history or data',
          value: _incognitoMode,
          onChanged: (value) {
            setState(() {
              _incognitoMode = value;
            });
          },
          color: const Color(0xFF607D8B),
        ),
      ],
    );
  }

  Widget _buildPrivacyActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Privacy Actions'),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                icon: Icons.delete_sweep_rounded,
                title: 'Clear Data',
                color: const Color(0xFFE91E63),
                onTap: _showClearDataDialog,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionButton(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Report',
                color: const Color(0xFF9C27B0),
                onTap: _showPrivacyReport,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildActionButton(
          icon: Icons.policy_rounded,
          title: 'Privacy Policy',
          color: const Color(0xFF2196F3),
          onTap: _showPrivacyPolicy,
          fullWidth: true,
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2D3748),
      ),
    );
  }

  Widget _buildPrivacyCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Switch(value: value, onChanged: onChanged, activeColor: color),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
    bool fullWidth = false,
  }) {
    return Container(
      width: fullWidth ? double.infinity : null,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPrivacyModeDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF9C27B0).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.privacy_tip_rounded,
                    color: Color(0xFF9C27B0),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text('Privacy Mode Enabled'),
              ],
            ),
            content: const Text(
              'Privacy mode is now active. Your sensitive information will be protected according to your privacy settings.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Got it'),
              ),
            ],
          ),
    );
  }

  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE91E63).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.delete_sweep_rounded,
                    color: Color(0xFFE91E63),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text('Clear Privacy Data'),
              ],
            ),
            content: const Text(
              'This will clear all cached data, browsing history, and temporary files. This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _clearPrivacyData();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE91E63),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Clear Data'),
              ),
            ],
          ),
    );
  }

  void _showPrivacyReport() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF9C27B0).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.privacy_tip_outlined,
                    color: Color(0xFF9C27B0),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text('Privacy Report'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Privacy Status:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildReportItem('Privacy Mode', _privacyModeEnabled),
                _buildReportItem('Analytics Disabled', _analyticsOptOut),
                _buildReportItem(
                  'Location Tracking Disabled',
                  _locationTrackingDisabled,
                ),
                _buildReportItem(
                  'Screenshot Protection',
                  _screenshotProtection,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Your privacy settings are helping protect your personal information.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  Widget _buildReportItem(String title, bool enabled) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            enabled ? Icons.check_circle : Icons.cancel,
            color: enabled ? Colors.green : Colors.red,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(title),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2196F3).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.policy_rounded,
                    color: Color(0xFF2196F3),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text('Privacy Policy'),
              ],
            ),
            content: const SingleChildScrollView(
              child: Text(
                'Task Manager Privacy Policy\n\n'
                '1. Data Collection: We collect minimal data necessary for app functionality.\n\n'
                '2. Data Usage: Your data is used only to provide and improve our services.\n\n'
                '3. Data Sharing: We do not share your personal data with third parties.\n\n'
                '4. Data Security: We implement industry-standard security measures.\n\n'
                '5. Your Rights: You can access, modify, or delete your data at any time.\n\n'
                'For more information, contact our privacy team.',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  void _clearPrivacyData() {
    // Simulate clearing data
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            const Text('Privacy data cleared successfully'),
          ],
        ),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
