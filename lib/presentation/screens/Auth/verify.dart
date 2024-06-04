import 'dart:async';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:otp_pin_field/otp_pin_field.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/data/services/api.dart';
import 'package:sudia_events/main.dart';
import 'package:sudia_events/presentation/screens/Auth/done.dart';
import 'package:sudia_events/presentation/screens/buttom_bar.dart';

// ignore: must_be_immutable
class VerifyScreen extends StatefulWidget {
  VerifyScreen({
    super.key,
    required this.verificationId,
    required this.phone,
    this.email,
    this.register,
  });
  final String verificationId;
  final String phone;
  String? email;
  bool? register;

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final _otpPinFieldController = GlobalKey<OtpPinFieldState>();
  bool isOtpComplete = false;

  Api api = Api();
  final int otpLength = 6; // Adjust the length of the OTP as needed

  bool loading = false;
  late Timer _timer;
  int _start = 15;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

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
                  Text(
                    "enter verify code".tr(),
                    style: TextStyle(fontSize: 30),
                  ),
                  Text(
                    "${"massage".tr()}${widget.phone.substring(widget.phone.length - 3)} ****** ${widget.phone.substring(0, 2)}",
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
                        setState(() {
                          isOtpComplete = true;
                        });
                        print('Entered pin is $text');

                        /// return the entered pin
                      },
                      onChange: (text) {
                        print('Enter on change pin is $text');

                        /// return the entered pin
                      },
                      onCodeChanged: (code) {
                        if (code.length == otpLength) {
                          setState(() {
                            isOtpComplete = true;
                          });
                        } else {
                          setState(() {
                            isOtpComplete = false;
                          });
                        }
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

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          "dont recieve".tr(),
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '00:$_start',
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.timer_sharp,
                            size: 17,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: _start == 0 ? _resendCode : null,
                        child: Text(
                          'resend'.tr(),
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    child: MaterialButton(
                      color: isOtpComplete ? primary : secondary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      minWidth: .7 * mediawidth(context),
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });
                        try {
                          PhoneAuthCredential credential =
                              await PhoneAuthProvider.credential(
                                  verificationId: widget.verificationId,
                                  smsCode: _otpPinFieldController
                                      .currentState!.text
                                      .toString());
                          FirebaseAuth.instance
                              .signInWithCredential(credential)
                              .then((value) async {
                            String uid = value.user!.uid;

                            widget.register!
                                ? await api.saveUserDataToFirestore(
                                    uid, widget.email ?? '', widget.phone)
                                : print('login UID $uid');
                            widget.register!
                                ? Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => BottomBarScreen(
                                              id: uid,
                                            )))
                                : Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => BottomBarScreen(
                                              id: uid,
                                            )));
                            sharedpref.setString('token', uid);
                          });
                        } catch (e) {
                          log(e.toString());
                        }
                      },
                      child: loading
                          ? Container(
                              width: 30,
                              height: 30,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                              ))
                          : Text(
                              "next".tr(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
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

  void _resendCode() {
    setState(() {
      _start = 15;
    });
    startTimer();
  }
}
