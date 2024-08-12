import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/data/model/event.dart';
import 'package:sudia_events/main.dart';
import 'package:sudia_events/presentation/screens/Auth/verify.dart';

class Api {
  String? verificationId;

  Future<void> verifyPhoneNumber(
    BuildContext context,
    TextEditingController phoneNumberController,
    String email,
    bool loading,
    Function(bool) setLoading,
    String name,
  ) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      setLoading(true);
      await auth.verifyPhoneNumber(
        phoneNumber: "+${phoneNumberController.text.trim()}",
        verificationCompleted: (PhoneAuthCredential credential) async {
          UserCredential userCredential =
              await auth.signInWithCredential(credential);

          print('User signed up: ${userCredential.user!.uid}');
        },
        verificationFailed: (FirebaseAuthException e) {
          print('Failed to verify phone number: ${e.message}');
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content:
                Text('Failed to verify phone number. Please try again later.'),
          ));
          setLoading(false);
        },
        codeSent: (String verificationId, int? resendToken) {
          this.verificationId = verificationId;

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => VerifyScreen(
                      verificationId: verificationId,
                      phone: phoneNumberController.text,
                      email: email,
                      register: true,
                      name: name,
                    )),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      print('Failed to verify phone number: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to verify phone number. Please try again later.'),
      ));
    }
  }

  Future<void> login(
    BuildContext context,
    String phone,
    bool loading,
    Function(bool) setLoading,
  ) async {
    FirebaseAuth auth = FirebaseAuth.instance;


    print("PHONE====$phone");

    try {
      setLoading(true); // Set loading to true before starting the login process
      await auth.verifyPhoneNumber(
        phoneNumber: '+201098489028',
        //phone,
        verificationCompleted: (PhoneAuthCredential credential) async {

          print("CREDDDDD====${credential.smsCode}");
          UserCredential userCredential =
              await auth.signInWithCredential(credential);

          print('User login : ${userCredential.user!.uid}');
        },
        verificationFailed: (FirebaseAuthException e) {
          print('Failed to verify phone number: ${e.message}');
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content:
                Text('Failed to verify phone number. Please try again later.'),
          ));
          setLoading(false); // Set loading to false if verification fails
        },
        codeSent: (String verificationId, int? resendToken) {
          this.verificationId = verificationId;

          print("resend======="+resendToken.toString());

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => VerifyScreen(
                      verificationId: verificationId,
                      phone: phone,
                      register: false,
                    )),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      print('Failed to verify phone number: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to verify phone number. Please try again later.'),
      ));
      setLoading(false); // Set loading to false if an exception occurs
    }
  }

  Future<User?> signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.pushNamed(context, buttomBar);
      return userCredential.user;
    } catch (e) {
      print("Error signing in: $e");
      return null;
    }
  }

  Future<void> saveUserDataToFirestore(
      String uid, String email, String phone, String name) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      await users.doc(uid).set({'email': email, 'phone': phone, 'name': name});

      print('User data saved to Firestore');
    } catch (e) {
      print('Error saving user data to Firestore: $e');
    }
  }

//*fetch events days
  Future<Map<DateTime, List<Event>>> fetchEventsFromFirestore() async {
    final events = <DateTime, List<Event>>{};
    String userId = sharedpref.getString('token')!;
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('reservation')
          .where('userID', isEqualTo: userId)
          .get();

      for (final doc in snapshot.docs) {
        final eventData = doc.data();

        // Check for null values before casting
        final eventDateString = eventData['date'] as String?;
        final eventName = eventData['name'] as String?;
        final phone = eventData['phone'] as String?;
        final type = eventData['type'] as String?;
        final uniquId = eventData['uniquID'] as String?;
        final cardid = eventData['cardId'] as String?;

        if (eventDateString == null ||
            eventName == null ||
            phone == null ||
            type == null ||
            uniquId == null) {
          // Skip this document if any required field is null
          continue;
        }

        final eventDateTime = DateTime.parse(eventDateString);

        if (events.containsKey(eventDateTime)) {
          events[eventDateTime]!.add(
            Event(
              date: eventDateTime,
              name: eventName,
              phone: phone,
              type: type,
              time: doc['time'], // Assuming doc['time'] is not null
              uniquID: uniquId, cardId: cardid??"",
            ),
          );
        } else {
          events[eventDateTime] = [
            Event(
              date: eventDateTime,
              name: eventName,
              phone: phone,
              type: type,
              time: doc['time'], // Assuming doc['time'] is not null
              uniquID: uniquId, cardId: cardid??"",
            ),
          ];
        }
      }
    } catch (e) {
      print("Error fetching events: $e");
    }

    return events;
  }

//*fetch data of events
  Future<List<Event>> fetchReservationData() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('reservation')
              .orderBy('date', descending: true)
              .get();

      final List<Event> reservationData = querySnapshot.docs
          .map((DocumentSnapshot<Map<String, dynamic>> doc) => Event(
                name: doc['name'] ?? "",
                date: DateTime.parse(doc['date']),
                phone: doc['phone'],
                type: doc['type'],
                time: doc['time'],
                uniquID: doc['uniquID'], cardId: doc['cardId']??"",
              ))
          .toList();

      return reservationData;
    } catch (e) {
      print("Error fetching reservation data: $e");
      return [];
    }
  }
}
