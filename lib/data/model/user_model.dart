class UserModel {
  // final String des;
  final String phone;
  final String name;
  final String email;
  final String img;

  UserModel({
    required this.phone,
    required this.name,
    required this.email,
    required this.img,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      phone: map['phone'],
      name: map['name'],
      email: map['email'],
      img: map['profileImageUr'] ?? "",
    );
  }
}
