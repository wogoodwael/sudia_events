// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:sudia_events/data/model/event.dart';

// Future<List<Event>> filterEventsByFamily(String familyName) async {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   List<Event> filteredData = [];

//   try {
//     QuerySnapshot querySnapshot = await _firestore
//         .collection('reservation')
//         .where('family', isEqualTo: familyName)
//         .get();

//     querySnapshot.docs.forEach((doc) {
//       // Extract individual fields from the document data
//       String eventName = doc['name'];
//       String eventPhone = doc['phone'];
//       String type = doc['type'];
//       String eventFamily = doc['family'];
//       String eventTribe = doc['tribe'];
//       final eventDateString = doc['date'] as String;
//       final eventDateTime = DateTime.parse(eventDateString);

//       // Create an Event object and add it to the filteredData list
//       Event event = Event(
//         name: eventName,
//         family: eventFamily,
//         tribe: eventTribe,
//         date: eventDateTime,
//         phone: eventPhone,
//         type: type,
//       );
//       filteredData.add(event);
//     });

//     return filteredData;
//   } catch (e) {
//     // Handle errors
//     print("Error filtering data: $e");
//     return [];
//   }
// }

// Future<List<Event>> filterEventsByTribe(String tribeName) async {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   List<Event> filteredData = [];

//   try {
//     QuerySnapshot querySnapshot = await _firestore
//         .collection('reservation')
//         .where('tribe', isEqualTo: tribeName)
//         .get();

//     querySnapshot.docs.forEach((doc) {
//       // Extract individual fields from the document data
//       String eventName = doc['name'];
//       String eventPhone = doc['phone'];
//       String type = doc['type'];
//       String eventFamily = doc['family'];
//       String eventTribe = doc['tribe'];
//       final eventDateString = doc['date'] as String;
//       final eventDateTime = DateTime.parse(eventDateString);

//       // Create an Event object and add it to the filteredData list
//       Event event = Event(
//         name: eventName,
//         family: eventFamily,
//         tribe: eventTribe,
//         date: eventDateTime,
//         phone: eventPhone,
//         type: type,
//       );
//       filteredData.add(event);
//     });

//     return filteredData;
//   } catch (e) {
//     // Handle errors
//     print("Error filtering data: $e");
//     return [];
//   }
// }

// Future<List<Event>> filterEventsByFamilyAndTribe(
//     String familyName, String tribeName) async {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   List<Event> filteredData = [];

//   try {
//     QuerySnapshot querySnapshot = await _firestore
//         .collection('reservation')
//         .where('family', isEqualTo: familyName)
//         .where('tribe', isEqualTo: tribeName) // Add filter for tribe
//         .get();

//     querySnapshot.docs.forEach((doc) {
//       // Extract individual fields from the document data
//       String eventName = doc['name'];
//       String eventPhone = doc['phone'];
//       String type = doc['type'];

//       String eventFamily = doc['family'];
//       String eventTribe = doc['tribe'];
//       final eventDateString = doc['date'] as String;
//       final eventDateTime = DateTime.parse(eventDateString);

//       // Create an Event object and add it to the filteredData list
//       Event event = Event(
//         name: eventName,
//         family: eventFamily,
//         tribe: eventTribe,
//         date: eventDateTime,
//         phone: eventPhone,
//         type: type,
//       );
//       filteredData.add(event);
//     });

//     return filteredData;
//   } catch (e) {
//     // Handle errors
//     print("Error filtering data: $e");
//     return [];
//   }
// }
