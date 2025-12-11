class AppUser {
  final String id;
  final String name;
  final String email;
  final bool isAdmin;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.isAdmin,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      isAdmin: json['isAdmin'] ?? false,
    );
  }
}
