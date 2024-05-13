class ServicesModel {
  // final String des;
  final String image;
  final String name;
  final int price;
  final String id;
  final String type;
  final String services_provider_email;
  final String services_provider_name;

  ServicesModel(
      {
        
      required this.id,
      required this.type,
      required this.image,
      required this.name,
      required this.price,
      required this.services_provider_email,
      required this.services_provider_name});

  factory ServicesModel.fromMap(Map<String, dynamic> map) {
    return ServicesModel(
      name: map['name'],
      // des: map['des'],
      image: map['image'],
      price: map['price'],
      services_provider_email: map['service_provider_email'],
      services_provider_name: map['service_provider_name'],
      id: map['id'],
      type: map['type'],
    );
  }
}
