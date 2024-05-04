import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/presentation/screens/Auth/verify.dart';

class Api {
  String? verificationId;

  Future<void> verifyPhoneNumber(BuildContext context,
      TextEditingController _phoneNumberController, String password, String email) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: _phoneNumberController.text.trim(),
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-retrieval of verification code completed.
          // Sign the user in (or link) with the auto-retrieved credential.
          UserCredential userCredential =
              await _auth.signInWithCredential(credential);

          // Navigate to next screen or perform necessary action after successful sign up
          print('User signed up: ${userCredential.user!.uid}');
        },
        verificationFailed: (FirebaseAuthException e) {
          // Handle verification failed errors
          print('Failed to verify phone number: ${e.message}');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text('Failed to verify phone number. Please try again later.'),
          ));
        },
        codeSent: (String verificationId, int? resendToken) {
          this.verificationId = verificationId;
          // Handle code sent to the device
          // You can prompt the user to enter the code manually
          // or use the `AutoRetrieve` option for auto-retrieval of the code
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => VerifyScreen(verificationId: verificationId, phone: _phoneNumberController.text, email: email,password: password, )),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Handle timeout
        },
      );
    } catch (e) {
      // Handle sign up errors
      print('Failed to verify phone number: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to verify phone number. Please try again later.'),
      ));
    }
  }

 Future<User?> signInWithEmailAndPassword(BuildContext context,String email, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
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
Future<void> saveUserDataToFirestore(String uid, String email, String password, String phone) async {
  try {
    // Get the reference to the Firestore collection 'users'
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    
    // Add a new document with the UID as the document ID
    await users.doc(uid).set({
      'email': email,
      'password': password,
      'phone':phone,
    });

    print('User data saved to Firestore');
  } catch (e) {
    print('Error saving user data to Firestore: $e');
  }
}
}
