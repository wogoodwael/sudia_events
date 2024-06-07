class MenuItem {
  final String des;
  final String image;
  final String price;

  final String rating;

  MenuItem({
    required this.des,
    required this.image,
    required this.price,
    required this.rating,
  });

  factory MenuItem.fromMap(Map<String, dynamic> map) {
    return MenuItem(
      des: map['des'],
      image: map['image'],
      price: map['price'],
      rating: map['rating'],
    );
  }
}
