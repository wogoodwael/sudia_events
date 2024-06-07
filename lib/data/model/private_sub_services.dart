class PrivateSubServices {
  final String des;
  final String image;
  final String price;
  final String name;

  final String rating;

  PrivateSubServices({
    required this.des,
    required this.image,
    required this.name,
    required this.price,
    required this.rating,
  });

  factory PrivateSubServices.fromMap(Map<String, dynamic> map) {
    return PrivateSubServices(
      name: map['fullName'],
      des: map['des'],
      image: map['image'],
      price: map['price'],
      rating: map['rating'],
    );
  }
}
