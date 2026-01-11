class User {
  final int id;
  final String name;
  final String role;
  final String email;
  final String location;
  final String avatarUrl;
  final List<String> tags;

  User({
    required this.id,
    required this.name,
    required this.role,
    required this.email,
    required this.location,
    required this.avatarUrl,
    required this.tags,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'] ?? 'Unknown',
      role: json['role'] ?? '',
      email: json['email'] ?? '',
      location: json['location'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
    );
  }
}
