class SubServicesModel {
  final List<dynamic> name;
  final List<dynamic> des;
  final List<dynamic> image;
  final List<dynamic> price;

  SubServicesModel({
    required this.des,
    required this.image,
    required this.name,
    required this.price,
  });

  factory SubServicesModel.fromMap(Map<String, dynamic> map) {
    return SubServicesModel(
      name: List<dynamic>.from(map['name']),
      des: List<dynamic>.from(map['des']),
      image: List<dynamic>.from(map['image']),
      price: List<dynamic>.from(map['price']),
    );
  }
}
