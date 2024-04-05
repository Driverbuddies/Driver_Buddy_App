class User1 {
  final String id;
  final String email;
  final String fullName;
  final String profileImageUrl;
  final String? googleId; // New field for Google Sign-In
  final String? googleAccessToken; // New field for Google Sign-In
  final String? googleIdToken; // New field for Google Sign-In
  final String? phoneNumber;
  User1({
    required this.id,
    required this.email,
    required this.fullName,
    required this.profileImageUrl,
    this.googleId,
    this.googleAccessToken,
    this.googleIdToken,
    this.phoneNumber,
  });

  factory User1.fromMap(Map<String, dynamic> map) {
    return User1(
      id: map['id'],
      email: map['email'],
      fullName: map['fullName'],
      profileImageUrl: map['profileImageUrl'],
      googleId: map['googleId'],
      googleAccessToken: map['googleAccessToken'],
      googleIdToken: map['googleIdToken'],
      phoneNumber: map['phoneNumber'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'profileImageUrl': profileImageUrl,
      'googleId': googleId,
      'googleAccessToken': googleAccessToken,
      'googleIdToken': googleIdToken,
      'phoneNumber': phoneNumber,
    };
  }
}
