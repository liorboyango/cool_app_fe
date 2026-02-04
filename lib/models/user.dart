class User {
  final int id;
  final String firstName;
  final String lastName;
  final String role;
  final String email;
  final String gender;
  final String? phoneNumber;
  final String? linkedinUrl;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.email,
    required this.gender,
    this.phoneNumber,
    this.linkedinUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as int,
        firstName: json['firstName'] as String,
        lastName: json['lastName'] as String,
        role: json['role'] as String,
        email: json['email'] as String,
        gender: json['gender'] as String,
        phoneNumber: json['phoneNumber'] as String?,
        linkedinUrl: json['linkedinUrl'] as String?,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'role': role,
        'email': email,
        'gender': gender,
        'phoneNumber': phoneNumber,
        'linkedinUrl': linkedinUrl,
      };

  String get fullName => '$firstName $lastName'.trim();
}