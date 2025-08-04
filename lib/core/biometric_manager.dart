import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class BiometricManager {
  static final BiometricManager _instance = BiometricManager._internal();
  factory BiometricManager() => _instance;
  BiometricManager._internal();

  static BiometricManager get instance => _instance;

  final LocalAuthentication _localAuth = LocalAuthentication();
  static const String _biometricEnabledKey = 'biometric_enabled';
  static const String _pinEnabledKey = 'pin_enabled';
  static const String _twoFactorEnabledKey = 'two_factor_enabled';
  static const String _autoLockEnabledKey = 'auto_lock_enabled';
  static const String _autoLockMinutesKey = 'auto_lock_minutes';
  static const String _showPasswordStrengthKey = 'show_password_strength';
  static const String _loginNotificationsKey = 'login_notifications';

  // Check if biometric authentication is available on the device
  Future<bool> isBiometricAvailable() async {
    try {
      final bool isAvailable = await _localAuth.canCheckBiometrics;
      final bool isDeviceSupported = await _localAuth.isDeviceSupported();
      return isAvailable && isDeviceSupported;
    } on PlatformException catch (e) {
      print('Error checking biometric availability: $e');
      return false;
    }
  }

  // Get available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print('Error getting available biometrics: $e');
      return [];
    }
  }

  // Authenticate using biometrics
  Future<bool> authenticateWithBiometrics({
    String localizedReason = 'Please authenticate to access the app',
  }) async {
    try {
      final bool isAuthenticated = await _localAuth.authenticate(
        localizedReason: localizedReason,
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
      return isAuthenticated;
    } on PlatformException catch (e) {
      print('Error during biometric authentication: $e');
      return false;
    }
  }

  // Save biometric settings
  Future<void> setBiometricEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_biometricEnabledKey, enabled);
  }

  // Get biometric settings
  Future<bool> isBiometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_biometricEnabledKey) ?? false;
  }

  // Save PIN settings
  Future<void> setPinEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_pinEnabledKey, enabled);
  }

  // Get PIN settings
  Future<bool> isPinEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_pinEnabledKey) ?? true;
  }

  // Save Two-Factor Authentication settings
  Future<void> setTwoFactorEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_twoFactorEnabledKey, enabled);
  }

  // Get Two-Factor Authentication settings
  Future<bool> isTwoFactorEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_twoFactorEnabledKey) ?? false;
  }

  // Save Auto Lock settings
  Future<void> setAutoLockEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_autoLockEnabledKey, enabled);
  }

  // Get Auto Lock settings
  Future<bool> isAutoLockEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_autoLockEnabledKey) ?? true;
  }

  // Save Auto Lock minutes
  Future<void> setAutoLockMinutes(int minutes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_autoLockMinutesKey, minutes);
  }

  // Get Auto Lock minutes
  Future<int> getAutoLockMinutes() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_autoLockMinutesKey) ?? 5;
  }

  // Save Password Strength settings
  Future<void> setShowPasswordStrength(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_showPasswordStrengthKey, enabled);
  }

  // Get Password Strength settings
  Future<bool> isShowPasswordStrength() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_showPasswordStrengthKey) ?? true;
  }

  // Save Login Notifications settings
  Future<void> setLoginNotifications(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loginNotificationsKey, enabled);
  }

  // Get Login Notifications settings
  Future<bool> isLoginNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loginNotificationsKey) ?? true;
  }

  // Initialize all security settings
  Future<Map<String, dynamic>> loadSecuritySettings() async {
    return {
      'biometricEnabled': await isBiometricEnabled(),
      'pinEnabled': await isPinEnabled(),
      'twoFactorEnabled': await isTwoFactorEnabled(),
      'autoLockEnabled': await isAutoLockEnabled(),
      'autoLockMinutes': await getAutoLockMinutes(),
      'showPasswordStrength': await isShowPasswordStrength(),
      'loginNotifications': await isLoginNotifications(),
    };
  }

  // Save all security settings
  Future<void> saveSecuritySettings(Map<String, dynamic> settings) async {
    if (settings.containsKey('biometricEnabled')) {
      await setBiometricEnabled(settings['biometricEnabled']);
    }
    if (settings.containsKey('pinEnabled')) {
      await setPinEnabled(settings['pinEnabled']);
    }
    if (settings.containsKey('twoFactorEnabled')) {
      await setTwoFactorEnabled(settings['twoFactorEnabled']);
    }
    if (settings.containsKey('autoLockEnabled')) {
      await setAutoLockEnabled(settings['autoLockEnabled']);
    }
    if (settings.containsKey('autoLockMinutes')) {
      await setAutoLockMinutes(settings['autoLockMinutes']);
    }
    if (settings.containsKey('showPasswordStrength')) {
      await setShowPasswordStrength(settings['showPasswordStrength']);
    }
    if (settings.containsKey('loginNotifications')) {
      await setLoginNotifications(settings['loginNotifications']);
    }
  }

  // Check if user should authenticate (based on enabled security features)
  Future<bool> shouldAuthenticate() async {
    final biometricEnabled = await isBiometricEnabled();
    final pinEnabled = await isPinEnabled();
    return biometricEnabled || pinEnabled;
  }

  // Perform authentication based on enabled methods
  Future<bool> performAuthentication() async {
    final biometricEnabled = await isBiometricEnabled();
    final biometricAvailable = await isBiometricAvailable();

    if (biometricEnabled && biometricAvailable) {
      return await authenticateWithBiometrics();
    }

    // If biometric is not available or enabled, you can implement PIN authentication here
    // For now, we'll return true (you can implement PIN dialog later)
    return true;
  }
}
