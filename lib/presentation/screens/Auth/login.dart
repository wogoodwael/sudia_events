import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sudia_events/core/helper/custom_checkBox.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/data/services/api.dart';
import 'package:sudia_events/presentation/screens/Auth/register.dart';

// ignore: must_be_immutable
class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool visable = false;
  bool value = false;
  bool register = false;
  bool login = false;
  bool loading = false;
  TextEditingController phone = TextEditingController();
  @override
  void initState() {
    super.initState();
    login = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: const Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20, top: 10),
                child: Text(
                  "ضيف",
                  style: TextStyle(color: primary, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Padding(
                padding: EdgeInsets.only(top: 25),
                child: ImageIcon(
                  AssetImage(
                    "assets/images/lang.png",
                  ),
                  size: 90,
                  color: primary,
                ),
              )
            ],
          )),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: mediawidth(context),
              height: 50,
              child: Image.asset(
                "assets/images/logo.png",
                color: primary,
              ),
            ),
          ),
          Expanded(
            flex: register ? 3 : 1,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            register = true;
                            login = false;
                          });
                        },
                        child: Container(
                          width: 150,
                          height: 50,
                          decoration: BoxDecoration(
                            color: register ? primary : Colors.white,
                            border: !register
                                ? Border.all(color: primary)
                                : Border.all(color: Colors.white),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "انشاء حساب ",
                              style: TextStyle(
                                color: register ? Colors.white : primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            register = false;
                            login = true;
                          });
                        },
                        child: Container(
                          width: 150,
                          height: 50,
                          decoration: BoxDecoration(
                            border: !login
                                ? Border.all(color: primary)
                                : Border.all(color: Colors.white),
                            color: login ? primary : Colors.white,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "تسجيل الدخول ",
                              style: TextStyle(
                                color: login ? Colors.white : primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          register
              ? RegisterScreen()
              : Expanded(
                  flex: 7,
                  child: Container(
                    width: .9 * mediawidth(context),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 52, // Increase height to account for border

                            child: const Padding(
                              padding: EdgeInsets.only(top: 20.0),
                              child: Text(
                                "رقم الجوال ",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ),
                            decoration: const BoxDecoration(
                                border:
                                    Border(bottom: BorderSide(color: primary))),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Center(
                            child: Container(
                              width: .8 * mediawidth(context),
                              height: 45,
                              decoration: BoxDecoration(
                                  border: Border.all(color: primary),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 8, right: 10, left: 5),
                                child: TextField(
                                  keyboardType: TextInputType.phone,
                                  textDirection: TextDirection.rtl,
                                  controller: phone,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText:
                                        '513245458                                    966',
                                    hintStyle:
                                        TextStyle(color: Colors.grey[300]),
                                    hintTextDirection: TextDirection.rtl,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                        CustomCheckBox(text: 'تذكرني')
                        
                         ],
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Center(
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              color: primary,
                              minWidth: 300,
                              onPressed: () async {
                                Api().login(context, phone, loading,
                                    (bool value) {
                                  setState(() {
                                    loading = value;
                                  });
                                });
                              },
                              child: loading
                                  ? Container(
                                      height: 30,
                                      width: 30,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ))
                                  : const Text(
                                      "دخول",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          Expanded(flex: 1, child: Container())
        ],
      ),
    );
  }
}
