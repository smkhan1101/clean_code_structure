class UserModel {
  final String id;
  final bool isUserExists;
  final String email;

  UserModel({
    required this.id,
    this.isUserExists = true,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      isUserExists: json['isUserExists'] ?? true,
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isUserExists': isUserExists,
      'email': email,
    };
  }
}

