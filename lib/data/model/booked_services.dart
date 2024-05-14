class BookedServicesModel {
  // final String des;
  final String des;
  final String name;
  final String price;

  final String type;

  BookedServicesModel({
    required this.type,
    required this.des,
    required this.name,
    required this.price,
  });

  factory BookedServicesModel.fromMap(Map<String, dynamic> map) {
    return BookedServicesModel(
      name: map['name'],
      des: map['des'],
      price: map['price'],
      type: map['type'],
    );
  }
}
