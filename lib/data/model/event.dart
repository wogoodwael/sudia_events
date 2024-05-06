class Event {
  final DateTime date;
  final String name;
  final String type;
  final String phone;
  final String gender;
  final String family;
  final String tribe;

  Event( {
    required this.family, required this.tribe,
    required this.date,
    required this.name,
    required this.type,
    required this.phone,
    required this.gender,
  });

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      date: DateTime.parse(map['date']),
      name: map['name'],
      type: map['type'],
      phone: map['phone'],
      gender: map['gender'],
      family: map['family'],
      tribe: map['tribe'],
    );
  }
}
