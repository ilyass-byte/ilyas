import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';

class ProfileManager extends ChangeNotifier {
  static final ProfileManager _instance = ProfileManager._internal();
  factory ProfileManager() => _instance;
  ProfileManager._internal();

  static ProfileManager get instance => _instance;

  static const String _profileKey = 'user_profile';
  
  UserProfile _currentProfile = UserProfile.defaultProfile;
  bool _isLoading = false;
  bool _isInitialized = false;

  // Getters
  UserProfile get currentProfile => _currentProfile;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;

  // Initialize the profile manager
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    _isLoading = true;
    notifyListeners();

    try {
      await _loadProfile();
      _isInitialized = true;
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing ProfileManager: $e');
      }
      // Use default profile if loading fails
      _currentProfile = UserProfile.defaultProfile;
      _isInitialized = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load profile from storage
  Future<void> _loadProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = prefs.getString(_profileKey);
      
      if (profileJson != null) {
        final profileMap = jsonDecode(profileJson) as Map<String, dynamic>;
        _currentProfile = UserProfile.fromJson(profileMap);
        if (kDebugMode) {
          print('Profile loaded successfully: ${_currentProfile.name}');
        }
      } else {
        // No saved profile, use default
        _currentProfile = UserProfile.defaultProfile;
        if (kDebugMode) {
          print('No saved profile found, using default');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading profile: $e');
      }
      _currentProfile = UserProfile.defaultProfile;
    }
  }

  // Save profile to storage
  Future<bool> saveProfile(UserProfile profile) async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final profileJson = jsonEncode(profile.toJson());
      
      final success = await prefs.setString(_profileKey, profileJson);
      
      if (success) {
        _currentProfile = profile;
        if (kDebugMode) {
          print('Profile saved successfully: ${profile.name}');
        }
      }
      
      return success;
    } catch (e) {
      if (kDebugMode) {
        print('Error saving profile: $e');
      }
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update specific profile fields
  Future<bool> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? bio,
    String? profileImagePath,
  }) async {
    final updatedProfile = _currentProfile.copyWith(
      name: name,
      email: email,
      phone: phone,
      bio: bio,
      profileImagePath: profileImagePath,
    );

    return await saveProfile(updatedProfile);
  }

  // Clear profile data (for logout, etc.)
  Future<bool> clearProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final success = await prefs.remove(_profileKey);
      
      if (success) {
        _currentProfile = UserProfile.defaultProfile;
        notifyListeners();
        if (kDebugMode) {
          print('Profile cleared successfully');
        }
      }
      
      return success;
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing profile: $e');
      }
      return false;
    }
  }

  // Check if profile has been customized (different from default)
  bool get isProfileCustomized {
    return _currentProfile != UserProfile.defaultProfile;
  }

  // Get profile completion percentage
  double get profileCompletionPercentage {
    int completedFields = 0;
    int totalFields = 4; // name, email, phone, bio

    if (_currentProfile.name.isNotEmpty) completedFields++;
    if (_currentProfile.email.isNotEmpty) completedFields++;
    if (_currentProfile.phone.isNotEmpty) completedFields++;
    if (_currentProfile.bio.isNotEmpty) completedFields++;

    return completedFields / totalFields;
  }

  // Validate email format
  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Validate phone format (basic validation)
  bool isValidPhone(String phone) {
    return phone.isNotEmpty && phone.length >= 10;
  }

  // Validate profile data
  Map<String, String?> validateProfile(UserProfile profile) {
    final errors = <String, String?>{};

    if (profile.name.isEmpty) {
      errors['name'] = 'Name is required';
    }

    if (profile.email.isEmpty) {
      errors['email'] = 'Email is required';
    } else if (!isValidEmail(profile.email)) {
      errors['email'] = 'Please enter a valid email';
    }

    if (profile.phone.isEmpty) {
      errors['phone'] = 'Phone is required';
    } else if (!isValidPhone(profile.phone)) {
      errors['phone'] = 'Please enter a valid phone number';
    }

    return errors;
  }
}
