class PrivateSubServices {
  final String des;
  final String image;
  final String price;
  final String name;
  final String dis;
  final List<dynamic> options;
  final List<dynamic> optionsprice;
  final String rating;
  final String about;
  PrivateSubServices({
    required this.des,
    required this.image,
    required this.name,
    required this.price,
    required this.about,
    required this.dis,
    required this.options,
    required this.optionsprice,
    required this.rating,
  });

  factory PrivateSubServices.fromMap(Map<String, dynamic> map) {
    return PrivateSubServices(
      name: map['fullName'],
      des: map['des'],
      image: map['image'],
      price: map['price'],
      rating: map['rating'],
      about: map['about'] ?? '',
      dis: map['dis'] ?? '',
      options: map['options'] != null ? List<dynamic>.from(map['options']) : [],
      optionsprice: map['options price'] != null
          ? List<dynamic>.from(map['options price'])
          : [],
    );
  }
}
