class AppUser {
  final String uid;
  final String name;
  final String dob;
  final String phone;
  final String role;
  final String email;

  AppUser({
    required this.uid,
    required this.name,
    required this.dob,
    required this.phone,
    required this.role,
    required this.email,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json["uid"] ?? "",
      name: json["name"] ?? "",
      dob: json["dob"] ?? "",
      phone: json["phone"] ?? "",
      role: json["role"] ?? "",
      email: json["email"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "name": name,
      "dob": dob,
      "phone": phone,
      "role": role,
      "email": email,
    };
  }
}
