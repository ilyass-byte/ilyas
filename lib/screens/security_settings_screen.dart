import 'package:flutter/material.dart';
import '../core/language.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  // Security settings state
  bool _biometricEnabled = false;
  bool _pinEnabled = true;
  bool _twoFactorEnabled = false;
  bool _autoLockEnabled = true;
  int _autoLockMinutes = 5;
  bool _showPasswordStrength = true;
  bool _loginNotifications = true;

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

  void _showSecurityTip(String title, String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                const Icon(Icons.security_rounded, color: Color(0xFF667EEA)),
                const SizedBox(width: 8),
                Text(title),
              ],
            ),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppLocalizations.translate('ok')),
              ),
            ],
          ),
    );
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
              colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF667EEA).withValues(alpha: 0.3),
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
          AppLocalizations.translate('security_settings'),
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
              // Header
              _buildSecurityHeader(),
              const SizedBox(height: 32),

              // Authentication Section
              _buildSectionTitle(AppLocalizations.translate('authentication')),
              const SizedBox(height: 16),
              _buildAuthenticationSection(),
              const SizedBox(height: 32),

              // Privacy & Protection Section
              _buildSectionTitle(
                AppLocalizations.translate('privacy_protection'),
              ),
              const SizedBox(height: 16),
              _buildPrivacySection(),
              const SizedBox(height: 32),

              // Security Monitoring Section
              _buildSectionTitle(
                AppLocalizations.translate('security_monitoring'),
              ),
              const SizedBox(height: 16),
              _buildMonitoringSection(),
              const SizedBox(height: 32),

              // Quick Actions
              _buildQuickActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecurityHeader() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF9800), Color(0xFFFF6F00)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF9800).withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.security_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.translate('security_center'),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            AppLocalizations.translate('protect_account_data'),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.shield_rounded,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'Active',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
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

  Widget _buildAuthenticationSection() {
    return Column(
      children: [
        _buildSecurityCard(
          icon: Icons.fingerprint_rounded,
          title: 'Biometric Authentication',
          subtitle: 'Use fingerprint or face recognition',
          value: _biometricEnabled,
          onChanged: (value) {
            setState(() {
              _biometricEnabled = value;
            });
            _showSecurityTip(
              'Biometric Security',
              'Biometric authentication adds an extra layer of security to your account.',
            );
          },
          color: const Color(0xFF4CAF50),
        ),
        const SizedBox(height: 16),
        _buildSecurityCard(
          icon: Icons.pin_rounded,
          title: 'PIN Protection',
          subtitle: 'Require PIN to access the app',
          value: _pinEnabled,
          onChanged: (value) {
            setState(() {
              _pinEnabled = value;
            });
          },
          color: const Color(0xFF2196F3),
        ),
        const SizedBox(height: 16),
        _buildSecurityCard(
          icon: Icons.verified_user_rounded,
          title: 'Two-Factor Authentication',
          subtitle: 'Add extra security with 2FA',
          value: _twoFactorEnabled,
          onChanged: (value) {
            setState(() {
              _twoFactorEnabled = value;
            });
            if (value) {
              _showSecurityTip(
                '2FA Enabled',
                'Two-factor authentication significantly improves your account security.',
              );
            }
          },
          color: const Color(0xFFFF9800),
        ),
      ],
    );
  }

  Widget _buildPrivacySection() {
    return Column(
      children: [
        _buildSecurityCard(
          icon: Icons.lock_clock_rounded,
          title: 'Auto Lock',
          subtitle: 'Lock app after $_autoLockMinutes minutes of inactivity',
          value: _autoLockEnabled,
          onChanged: (value) {
            setState(() {
              _autoLockEnabled = value;
            });
          },
          color: const Color(0xFF9C27B0),
          trailing:
              _autoLockEnabled
                  ? IconButton(
                    icon: const Icon(Icons.settings_rounded),
                    onPressed: _showAutoLockSettings,
                  )
                  : null,
        ),
        const SizedBox(height: 16),
        _buildSecurityCard(
          icon: Icons.password_rounded,
          title: 'Password Strength Indicator',
          subtitle: 'Show password strength when creating passwords',
          value: _showPasswordStrength,
          onChanged: (value) {
            setState(() {
              _showPasswordStrength = value;
            });
          },
          color: const Color(0xFFE91E63),
        ),
      ],
    );
  }

  Widget _buildMonitoringSection() {
    return Column(
      children: [
        _buildSecurityCard(
          icon: Icons.notifications_active_rounded,
          title: 'Login Notifications',
          subtitle: 'Get notified of new login attempts',
          value: _loginNotifications,
          onChanged: (value) {
            setState(() {
              _loginNotifications = value;
            });
          },
          color: const Color(0xFF00BCD4),
        ),
      ],
    );
  }

  Widget _buildSecurityCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color color,
    Widget? trailing,
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
            if (trailing != null) trailing,
            const SizedBox(width: 8),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: color,
              activeTrackColor: color.withValues(alpha: 0.3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(AppLocalizations.translate('quick_actions')),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                icon: Icons.key_rounded,
                title: AppLocalizations.translate('change_password'),
                color: const Color(0xFFE91E63),
                onTap: _showChangePasswordDialog,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionButton(
                icon: Icons.history_rounded,
                title: AppLocalizations.translate('security_log'),
                color: const Color(0xFF607D8B),
                onTap: _showSecurityLog,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: _buildActionButton(
            icon: Icons.security_update_rounded,
            title: AppLocalizations.translate('security_checkup'),
            color: const Color(0xFF4CAF50),
            onTap: _performSecurityCheckup,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
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
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAutoLockSettings() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Auto Lock Settings'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Select auto lock time:'),
                const SizedBox(height: 16),
                ...([1, 5, 10, 15, 30].map(
                  (minutes) => RadioListTile<int>(
                    title: Text('$minutes minutes'),
                    value: minutes,
                    groupValue: _autoLockMinutes,
                    onChanged: (value) {
                      setState(() {
                        _autoLockMinutes = value!;
                      });
                      Navigator.pop(context);
                    },
                  ),
                )),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppLocalizations.translate('cancel')),
              ),
            ],
          ),
    );
  }

  void _showChangePasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Change Password'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: currentPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Current Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'New Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirm New Password',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppLocalizations.translate('cancel')),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppLocalizations.translate(
                          'password_changed_successfully',
                        ),
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: Text(AppLocalizations.translate('save')),
              ),
            ],
          ),
    );
  }

  void _showSecurityLog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Security Log'),
            content: SizedBox(
              width: double.maxFinite,
              height: 300,
              child: ListView(
                children: [
                  _buildLogItem(
                    'Login successful',
                    'Today, 10:30 AM',
                    Icons.login_rounded,
                    Colors.green,
                  ),
                  _buildLogItem(
                    'Password changed',
                    'Yesterday, 3:45 PM',
                    Icons.key_rounded,
                    Colors.blue,
                  ),
                  _buildLogItem(
                    'Failed login attempt',
                    '2 days ago, 11:20 PM',
                    Icons.warning_rounded,
                    Colors.orange,
                  ),
                  _buildLogItem(
                    '2FA enabled',
                    '1 week ago, 2:15 PM',
                    Icons.security_rounded,
                    Colors.green,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppLocalizations.translate('ok')),
              ),
            ],
          ),
    );
  }

  Widget _buildLogItem(String title, String time, IconData icon, Color color) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title),
      subtitle: Text(time),
      dense: true,
    );
  }

  void _performSecurityCheckup() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                const Icon(Icons.security_rounded, color: Color(0xFF4CAF50)),
                const SizedBox(width: 8),
                const Text('Security Checkup'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCheckupItem('Strong password', true),
                _buildCheckupItem(
                  'Two-factor authentication',
                  _twoFactorEnabled,
                ),
                _buildCheckupItem('Biometric security', _biometricEnabled),
                _buildCheckupItem('Auto-lock enabled', _autoLockEnabled),
                _buildCheckupItem('Login notifications', _loginNotifications),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.shield_rounded,
                        color: Color(0xFF4CAF50),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Your account security is good!',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF4CAF50),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(AppLocalizations.translate('ok')),
              ),
            ],
          ),
    );
  }

  Widget _buildCheckupItem(String title, bool isEnabled) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            isEnabled ? Icons.check_circle_rounded : Icons.cancel_rounded,
            color: isEnabled ? Colors.green : Colors.red,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: isEnabled ? Colors.green : Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
