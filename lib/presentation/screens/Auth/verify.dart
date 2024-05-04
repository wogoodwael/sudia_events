import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:otp_pin_field/otp_pin_field.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/data/services/api.dart';
import 'package:sudia_events/presentation/screens/Auth/done.dart';

class VerifyScreen extends StatelessWidget {
  VerifyScreen({
    super.key,
    required this.verificationId,
    required this.phone,
    required this.email,
    required this.password,
  });
  final _otpPinFieldController = GlobalKey<OtpPinFieldState>();
  final String verificationId;
  final String phone;
  final String email;
  final String password;
  Api api = Api();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              width: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: .1 * MediaQuery.sizeOf(context).height,
                  ),
                  const Text(
                    "ادخل رمز التحقق ",
                    style: TextStyle(fontSize: 30),
                  ),
                  Text(
                    "لقد ارسلنا رمز التحقق الي +65595****125",
                    style: TextStyle(color: Colors.grey, fontSize: 17),
                  ),

                  //^ come from backend
                  OtpPinField(
                      key: _otpPinFieldController,
                      autoFillEnable: false,
                      fieldWidth: 50,
                      fieldHeight: 70,

                      ///for Ios it is not needed as the SMS autofill is provided by default, but not for Android, that's where this key is useful.
                      textInputAction: TextInputAction.done,

                      ///in case you want to change the action of keyboard
                      /// to clear the Otp pin Controller
                      onSubmit: (text) {
                        print('Entered pin is $text');

                        /// return the entered pin
                      },
                      onChange: (text) {
                        print('Enter on change pin is $text');

                        /// return the entered pin
                      },
                      onCodeChanged: (code) {
                        print('onCodeChanged  is $code');
                      },

                      /// to decorate your Otp_Pin_Field
                      otpPinFieldStyle: const OtpPinFieldStyle(
                        // ignore: prefer_const_constructors
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),

                        /// border color for inactive/unfocused Otp_Pin_Field
                        defaultFieldBorderColor: Color(0xfff5f5f5),

                        /// border color for active/focused Otp_Pin_Field
                        activeFieldBorderColor: primary,

                        /// Background Color for inactive/unfocused Otp_Pin_Field
                        defaultFieldBackgroundColor: Color(0xfff5f5f5),

                        /// Background Color for active/focused Otp_Pin_Field
                        activeFieldBackgroundColor: Colors.white,

                        /// Background Color for filled field pin box
                        filledFieldBackgroundColor: primary,

                        /// border Color for filled field pin box
                        filledFieldBorderColor: primary,
                      ),
                      maxLength: 6,

                      /// no of pin field
                      showCursor: true,

                      /// bool to show cursor in pin field or not
                      cursorColor: primary,

                      /// to choose cursor color

                      middleChild: const Column(
                        children: [
                          SizedBox(height: 30),
                          SizedBox(height: 10),
                        ],
                      ),
                      showCustomKeyboard: false,
                      showDefaultKeyboard: true,
                      cursorWidth: 3,
                      mainAxisAlignment: MainAxisAlignment.center,
                      otpPinFieldDecoration:
                          OtpPinFieldDecoration.defaultPinBoxDecoration),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "  تسجيل الخروج ",
                        style: TextStyle(color: Colors.red),
                      ),
                      Icon(
                        Icons.logout,
                        size: 15,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text("اعاده ارسال الرمز "),
                      Icon(
                        Icons.restore,
                        size: 17,
                      ),
                    ],
                  ),
                  FittedBox(
                    child: Row(
                      children: [
                        Text(
                            "اذا كنت تواجه مشكله في تسجيل الدخول تواصل مع خدمه العملاء "),
                        Icon(
                          Icons.headset_mic,
                          size: 17,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: MaterialButton(
                      color: primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      minWidth: .7 * mediawidth(context),
                      onPressed: () async {
                        try {
                          PhoneAuthCredential credential =
                              await PhoneAuthProvider.credential(
                                  verificationId: verificationId,
                                  smsCode: _otpPinFieldController
                                      .currentState!.text
                                      .toString());
                          FirebaseAuth.instance
                              .signInWithCredential(credential)
                              .then((value) async {
                            String uid = value.user!.uid;

                            // Save user data to Firestore
                            await api.saveUserDataToFirestore(
                                uid, email, password, phone);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => DoneScreen(
                                        email: email, password: password)));
                          });
                        } catch (e) {
                          log(e.toString());
                        }
                      },
                      child: Text(
                        "تحقق",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
