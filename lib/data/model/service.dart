class Service {
  final String name;
  final String status;
  final String description;
  final String imageUrl;
  final String rating;
  final bool hasDelivery;
  final String distance;

  Service({
    required this.name,
    required this.status,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.hasDelivery,
    required this.distance,
  });

  factory Service.fromFirestore(Map<String, dynamic> data) {
    return Service(
      name: data['name'] ?? '',
      status: data['status'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      rating: data['rating'] ?? 0.0,
      hasDelivery: data['hasDelivery'] ?? false,
      distance: data['distance'] ?? '',
    );
  }
}
