class User {
  String id;
  String email;
  String fullName;
  List<String> roles;
  String token;
  User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.roles,
    required this.token,
  });

  bool get isAdmin{
    return roles.contains('admin');
  }

}
