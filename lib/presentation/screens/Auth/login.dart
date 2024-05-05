import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
                            height: 20,
                          ),
                          Center(
                            child: Container(
                              width: .8 * mediawidth(context),
                              height: 45,
                              decoration: BoxDecoration(
                                  border: Border.all(color: primary),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, right: 10),
                                child: TextField(
                                  controller: phone,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '513245458',
                                    hintStyle:
                                        TextStyle(color: Colors.grey[300]),
                                    hintTextDirection: TextDirection.rtl,
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text("966",
                                          style: TextStyle(
                                              color: Colors.grey[300],
                                              fontSize: 18)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 13.0, bottom: 10),
                            child: Text(
                              "الرقم السري",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Center(
                            child: Container(
                              width: .8 * mediawidth(context),
                              height: 45,
                              decoration: BoxDecoration(
                                  border: Border.all(color: primary),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 8, right: 10),
                                child: TextField(
                                  obscureText: !visable,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '0000',
                                    hintStyle:
                                        TextStyle(color: Colors.grey[300]),
                                    hintTextDirection: TextDirection.rtl,
                                    prefixIcon: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8, bottom: 4),
                                        child: !visable
                                            ? GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    visable = !visable;
                                                  });
                                                },
                                                child: const Icon(
                                                  Icons.visibility_off,
                                                  size: 20,
                                                  color: Colors.grey,
                                                ),
                                              )
                                            : GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    visable = !visable;
                                                  });
                                                },
                                                child: const Icon(
                                                  Icons.visibility,
                                                  size: 20,
                                                  color: Colors.grey,
                                                ),
                                              )),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 15.0),
                                child: Text(
                                  "نسيت الرقم السري",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "تذكرني",
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Transform.scale(
                                    scale: .6,
                                    child: Checkbox(
                                      activeColor: primary,
                                      visualDensity: VisualDensity.compact,
                                      value:
                                          value, // Set the initial value of the checkbox
                                      onChanged: (bool? value) {
                                        setState(() {
                                          this.value = value!;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 60,
                          ),
                          Center(
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              color: primary,
                              minWidth: 300,
                              onPressed: () async {
                                setState(() {
                                  loading = true;
                                });
                                await Api().login(context, phone);
                              },
                              child: loading
                                  ? Container(
                                      width: 30,
                                      height: 30,
                                      child: const CircularProgressIndicator(
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
