class Event {
  final DateTime date;
  final String name;
  final String type;
  final String phone;
  final String gender;

  Event( {
    required this.date,
    required this.name,
    required this.type,
    required this.phone, required this.gender,
  });

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      date: DateTime.parse(map['date']),
      name: map['name'],
      type: map['type'],
      phone:map['phone'], gender: map['gender'],

    );
  }
}
