class UserModel {
  // final String des;
  final String phone;
  final String name;
  final String email;


  UserModel({
    required this.phone,
    required this.name,
    required this.email,

  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      phone: map['phone'],
      name: map['name'],
      email: map['email'],

    );
  }
}
