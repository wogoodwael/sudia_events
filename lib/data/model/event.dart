class Event {
  final DateTime date;
  final String name;

  final String phone;
  final String type;
  final String family;
  final String tribe;
  final String time;
  final String uniquID;

  Event( {
    required this.family,
    required this.uniquID,
    required this.time,
    required this.tribe,
    required this.date,
    required this.type,
    required this.name,
    required this.phone,
  });

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      date: DateTime.parse(map['date']),
      name: map['name'],
      phone: map['phone'],
      family: map['family'],
      tribe: map['tribe'],
      type: map['type'],
      time: map['time'] ?? "", uniquID: map['uniquID'],
    );
  }
}
