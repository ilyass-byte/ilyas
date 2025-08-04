class UserProfile {
  final String name;
  final String email;
  final String phone;
  final String bio;
  final String? profileImagePath;

  const UserProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.bio,
    this.profileImagePath,
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'bio': bio,
      'profileImagePath': profileImagePath,
    };
  }

  // Create from JSON
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      bio: json['bio'] ?? '',
      profileImagePath: json['profileImagePath'],
    );
  }

  // Create a copy with updated values
  UserProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? bio,
    String? profileImagePath,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      profileImagePath: profileImagePath ?? this.profileImagePath,
    );
  }

  // Default profile for new users
  static const UserProfile defaultProfile = UserProfile(
    name: 'Ahmed Mohamed',
    email: 'ahmed.mohamed@example.com',
    phone: '+20 123 456 7890',
    bio: 'Task management enthusiast',
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile &&
        other.name == name &&
        other.email == email &&
        other.phone == phone &&
        other.bio == bio &&
        other.profileImagePath == profileImagePath;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        bio.hashCode ^
        profileImagePath.hashCode;
  }

  @override
  String toString() {
    return 'UserProfile(name: $name, email: $email, phone: $phone, bio: $bio, profileImagePath: $profileImagePath)';
  }
}
