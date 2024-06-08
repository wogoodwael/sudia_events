class MenuItem {
  final String des;
  final String image;
  final String price;
  final String about;
  final String dis;
  final List<dynamic> options;
  final List<dynamic> optionsprice;
  final String rating;

  MenuItem({
    required this.about,
    required this.dis,
    required this.options,
    required this.optionsprice,
    required this.des,
    required this.image,
    required this.price,
    required this.rating,
  });

  factory MenuItem.fromMap(Map<String, dynamic> map) {
    return MenuItem(
      des: map['des'] ?? '',
      image: map['image'] ?? '',
      price: map['price'] ?? '',
      rating: map['rating'] ?? '',
      about: map['about'] ?? '',
      dis: map['dis'] ?? '',
      options: map['options'] != null ? List<dynamic>.from(map['options']) : [],
      optionsprice: map['options price'] != null ? List<dynamic>.from(map['options price']) : [],
    );
  }
}
