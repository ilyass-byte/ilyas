import 'package:flutter/material.dart';
import '../core/language.dart';
import '../core/backup_manager.dart';
import '../localized_app.dart';
import 'dashboard_screen.dart';

class BackupScreen extends StatefulWidget {
  const BackupScreen({super.key});

  @override
  State<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen>
    with TickerProviderStateMixin, LocalizationMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final BackupManager _backupManager = BackupManager.instance;
  int _totalTasks = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _loadBackupInfo();
    _backupManager.addListener(_onBackupStateChanged);
    _animationController.forward();
  }

  @override
  void dispose() {
    _backupManager.removeListener(_onBackupStateChanged);
    _animationController.dispose();
    super.dispose();
  }

  void _onBackupStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _loadBackupInfo() {
    setState(() {
      _totalTasks = 25; // This would come from actual data
    });
    _backupManager.initialize();
  }

  Future<void> _performBackup() async {
    // Get sample tasks for backup
    final sampleTasks = _getSampleTasks();
    final success = await _backupManager.createBackup(sampleTasks);

    if (success) {
      _showSuccessMessage('Backup completed successfully!');
    } else {
      _showErrorMessage('Backup failed. Please try again.');
    }
  }

  Future<void> _performRestore() async {
    final confirmed = await _showConfirmDialog(
      'Restore Backup',
      'This will replace all current data with the backup. Are you sure?',
    );

    if (!confirmed) return;

    final restoredTasks = await _backupManager.restoreBackup();

    if (restoredTasks != null) {
      _showSuccessMessage('Data restored successfully!');
      // In a real app, you would update the main task list here
    } else {
      _showErrorMessage('Restore failed. Please try again.');
    }
  }

  List<Task> _getSampleTasks() {
    // Return sample tasks for backup
    return [
      Task(
        id: '1',
        title: 'Complete Flutter Project',
        description: 'Finish the dashboard UI implementation',
        category: TaskCategory.immediate,
        dueDate: DateTime.now().add(const Duration(days: 1)),
        priority: Priority.high,
        progress: 0.7,
      ),
      Task(
        id: '2',
        title: 'Prepare for Meeting',
        description: 'Review presentation slides and prepare notes',
        category: TaskCategory.dueSoon,
        dueDate: DateTime.now().add(const Duration(days: 2)),
        priority: Priority.medium,
        progress: 0.4,
      ),
    ];
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<bool> _showConfirmDialog(String title, String content) async {
    return await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text(title),
                content: Text(content),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(AppLocalizations.translate('cancel')),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(AppLocalizations.translate('yes')),
                  ),
                ],
              ),
        ) ??
        false;
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
              colors: [Color(0xFF00BCD4), Color(0xFF0097A7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00BCD4).withValues(alpha: 0.3),
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
          AppLocalizations.translate('backup'),
          style: const TextStyle(
            color: Color(0xFF2D3748),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Header Card
            _buildHeaderCard(),
            const SizedBox(height: 24),

            // Backup Actions
            _buildBackupActions(),
            const SizedBox(height: 24),

            // Backup Information
            _buildBackupInfo(),
            const SizedBox(height: 24),

            // Settings
            _buildBackupSettings(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00BCD4), Color(0xFF0097A7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00BCD4).withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FadeTransition(
        opacity: _fadeAnimation,
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
                    Icons.backup_rounded,
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
                        'Data Backup',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Keep your tasks safe',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (_backupManager.isBackingUp || _backupManager.isRestoring) ...[
              const SizedBox(height: 20),
              LinearProgressIndicator(
                value: _backupManager.backupProgress,
                backgroundColor: Colors.white.withValues(alpha: 0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 6,
              ),
              const SizedBox(height: 8),
              Text(
                _backupManager.isBackingUp ? 'Backing up...' : 'Restoring...',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBackupActions() {
    return Column(
      children: [
        // Create Backup Button
        _buildActionCard(
          icon: Icons.backup_rounded,
          title: 'Create Backup',
          subtitle: 'Save all your tasks and settings',
          color: const Color(0xFF4CAF50),
          onTap:
              _backupManager.isBackingUp || _backupManager.isRestoring
                  ? null
                  : _performBackup,
          isLoading: _backupManager.isBackingUp,
        ),
        const SizedBox(height: 16),

        // Restore Backup Button
        _buildActionCard(
          icon: Icons.restore_rounded,
          title: 'Restore Backup',
          subtitle: 'Restore from previous backup',
          color: const Color(0xFFFF9800),
          onTap:
              _backupManager.isBackingUp || _backupManager.isRestoring
                  ? null
                  : _performRestore,
          isLoading: _backupManager.isRestoring,
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback? onTap,
    bool isLoading = false,
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
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
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
                if (isLoading)
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.grey[400],
                    size: 16,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackupInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: const Color(0xFF00BCD4),
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                'Backup Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Status', _backupManager.backupStatus),
          const SizedBox(height: 12),
          _buildInfoRow('Total Tasks', '$_totalTasks tasks'),
          const SizedBox(height: 12),
          _buildInfoRow(
            'Last Backup',
            _backupManager.lastBackupDate != null
                ? '${_backupManager.lastBackupDate!.day}/${_backupManager.lastBackupDate!.month}/${_backupManager.lastBackupDate!.year}'
                : 'Never',
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            'Backup Size',
            _backupManager.getBackupSizeEstimate(_getSampleTasks()),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
      ],
    );
  }

  Widget _buildBackupSettings() {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.settings_rounded,
                color: const Color(0xFF00BCD4),
                size: 24,
              ),
              const SizedBox(width: 12),
              const Text(
                'Backup Settings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSettingItem(
            'Auto Backup',
            'Automatically backup daily',
            _backupManager.autoBackupEnabled,
            (value) {
              _backupManager.setAutoBackup(value);
            },
          ),
          const SizedBox(height: 16),
          _buildSettingItem(
            'Include Settings',
            'Backup app settings and preferences',
            _backupManager.includeSettings,
            (value) {
              _backupManager.setIncludeSettings(value);
            },
          ),
          const SizedBox(height: 16),
          _buildSettingItem(
            'Cloud Sync',
            'Sync backups to cloud storage',
            _backupManager.cloudSyncEnabled,
            (value) {
              _backupManager.setCloudSync(value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
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
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF00BCD4),
        ),
      ],
    );
  }
}
