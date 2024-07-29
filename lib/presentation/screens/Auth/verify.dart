import 'dart:async';
import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:otp_pin_field/otp_pin_field.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/data/services/api.dart';
import 'package:sudia_events/main.dart';
import 'package:sudia_events/presentation/screens/buttom_bar.dart';

// ignore: must_be_immutable
class VerifyScreen extends StatefulWidget {
  VerifyScreen({
    super.key,
    required this.verificationId,
    required this.phone,
    this.email,
    this.register,  this.name,
  });

  final String verificationId;
  final String phone;
 String ?name;
  String? email;
  bool? register;

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final _otpPinFieldController = GlobalKey<OtpPinFieldState>();
  bool isOtpComplete = false;
  Api api = Api();
  final int otpLength = 6;
  bool loading = false;
  late Timer _timer;
  int _start = 15;
  
  String enteredOtp='';

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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


  Future<void> _requestLocationPermissionAndFetchLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, handle it gracefully.
        log('Location permissions are denied.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle it gracefully.
      log('Location permissions are permanently denied, we cannot request permissions.');
      return;
    }

    // When we reach here, permissions are granted or are already granted,
    // we can fetch the location now.
    _fetchLocation();
  }

  void _fetchLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      // Handle position data as needed, e.g., save to Firestore.
      log('Location fetched: ${position.latitude}, ${position.longitude}');
      sharedpref.setDouble('lat', position.latitude);
      sharedpref.setDouble('long', position.longitude);
    } catch (e) {
      log('Error fetching location: $e');
      // Handle error fetching location.
    }
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
              child: SizedBox(
                width: 400,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      height: 0.1 * MediaQuery.of(context).size.height,
                    ),
                    Text(
                      "enter verify code".tr(),
                      style: const TextStyle(fontSize: 30),
                    ),
                    Text(
                      "${"massage".tr()}${widget.phone.substring(widget.phone.length - 3)} ****** ${widget.phone.substring(0, 2)}",
                      style: const TextStyle(color: Colors.grey, fontSize: 17),
                    ),
                    OtpPinField(
                      
                      key: _otpPinFieldController,
                      autoFillEnable: false,
                      fieldWidth: 50,
                      fieldHeight: 70,
                      textInputAction: TextInputAction.done,
                      onSubmit: (text) {
                        setState(() {
                          isOtpComplete = true;
                                        enteredOtp = text;

                        });
                        // ignore: avoid_print
                        print('Entered pin is $text');
                      },
                      onChange: (text) {
                        // ignore: avoid_print
                        print('Enter on change pin is $text');
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
                      otpPinFieldStyle: const OtpPinFieldStyle(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        defaultFieldBorderColor: Color(0xfff5f5f5),
                        activeFieldBorderColor: primary,
                        defaultFieldBackgroundColor: Color(0xfff5f5f5),
                        activeFieldBackgroundColor: Colors.white,
                        filledFieldBackgroundColor: primary,
                        filledFieldBorderColor: primary,
                      ),
                      maxLength: 6,
                      showCursor: true,
                      cursorColor: primary,
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
                          OtpPinFieldDecoration.defaultPinBoxDecoration,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            "dont recieve".tr(),
                            style: const TextStyle(fontSize: 17),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '00:$_start',
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Icon(
                              Icons.timer_sharp,
                              size: 17,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: _start == 0 ? _resendCode : null,
                          child: Text(
                            'resend'.tr(),
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      child: MaterialButton(
                        color: isOtpComplete ? primary : primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        minWidth: 0.7 * MediaQuery.of(context).size.width,
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });
                          try {
                            
                            if(enteredOtp.replaceAll('+', '').contains(widget.verificationId)){
                              print("DONE");
                            }else{
                              print("NOT DONE");
                              print("dddd===+"+enteredOtp);
                              print("verrrr=="+widget.verificationId);
                            }



                            PhoneAuthCredential credential =
                                PhoneAuthProvider.credential(
                              verificationId: widget.verificationId,
                              smsCode: enteredOtp
                            );


                            FirebaseAuth.instance
                                .signInWithCredential(credential)
                                .then((value) async {
                              String uid = value.user!.uid;
                              widget.register!
                                  ? await api.saveUserDataToFirestore(
                                      uid, widget.email ?? '', widget.phone, widget.name??"")
                                  : print('login UID $uid');

                              // Request location permission and fetch location
                              await _requestLocationPermissionAndFetchLocation();

                              try {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => BottomBarScreen(id: uid)),
                                );
                                // Replace sharedpref with your actual implementation
                                sharedpref.setString('token', uid);
                              } catch (e) {
                                log('Navigation error: $e');
                              }
                            });
                          } catch (e) {
                            log(e.toString());
                          }
                        },
                        child: loading
                            ? const SizedBox(
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                "next".tr(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _resendCode() {
    setState(() {
      _start = 15;
    });
    startTimer();
  }
}
