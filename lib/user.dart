class User {
  final int id;
  final String name;
  final String location;
  final String avatarUrl;
  final List<String> tags;

  User({
    required this.id,
    required this.name,
    required this.location,
    required this.avatarUrl,
    required this.tags,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'] ?? 'Unknown',
      location: json['location'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
    );
  }
}
