class ResturantDetailsModel {
  final List<dynamic> dishes;
  final List<dynamic> discount;
  final List<dynamic> overview;
  final List<dynamic> price;
  final List<dynamic> image;

  ResturantDetailsModel({
    required this.dishes,
    required this.image,
    required this.discount,
    required this.price,
    required this.overview,
  });

  factory ResturantDetailsModel.fromMap(Map<String, dynamic> map) {
    return ResturantDetailsModel(
     
      image: List<dynamic>.from(map['image']),
      price: List<dynamic>.from(map['price']),
       dishes: List<dynamic>.from(map['dishes']), 
       discount: List<dynamic>.from(map['discount']), overview:List<dynamic>.from(map['overview']),
    );
  }
}
