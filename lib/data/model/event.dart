class Event {
  final DateTime date;
  final String name;

  final String phone;
  final String type;

  final String time;
  final String uniquID;

  Event({
    required this.uniquID,
    required this.time,
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
      type: map['type'],
      time: map['time'] ?? "",
      uniquID: map['uniquID'],
    );
  }
}
