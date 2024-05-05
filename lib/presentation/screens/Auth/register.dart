import 'package:flutter/material.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/data/services/api.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool visable = false;
  bool value = false;
  Api api = Api();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 17,
      child: Container(
        width: .9 * mediawidth(context),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 13.0, bottom: 5, top: 10),
                child: Text(
                  "الاسم",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                    padding: const EdgeInsets.only(top: 8, right: 10),
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'الاسم',
                        hintStyle: TextStyle(color: Colors.grey[300]),
                        hintTextDirection: TextDirection.rtl,
                        prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 8, bottom: 4),
                            child: Icon(
                              Icons.person,
                              color: Colors.grey,
                            )),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: 100,
                height: 52, // Increase height to account for border

                child: const Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Text(
                    "رقم الجوال ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: primary))),
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
                    padding: const EdgeInsets.only(top: 8, right: 10),
                    child: TextField(
                      controller: phone,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '513245458',
                        hintStyle: TextStyle(color: Colors.grey[300]),
                        hintTextDirection: TextDirection.rtl,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text("966",
                              style: TextStyle(
                                  color: Colors.grey[300], fontSize: 18)),
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
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                    padding: const EdgeInsets.only(top: 8, right: 10),
                    child: TextField(
                      controller: password,
                      obscureText: !visable,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '0000',
                        hintStyle: TextStyle(color: Colors.grey[300]),
                        hintTextDirection: TextDirection.rtl,
                        prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 8, bottom: 4),
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
              const Padding(
                padding: EdgeInsets.only(right: 13.0, bottom: 10),
                child: Text(
                  "البريد الالكتروني ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                    padding: const EdgeInsets.only(top: 8, right: 10),
                    child: TextField(
                      controller: email,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'اختياري - لتلقي العروض والتخفيضات',
                        hintStyle: TextStyle(color: Colors.grey[300]),
                        hintTextDirection: TextDirection.rtl,
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    "تذكرني",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  Transform.scale(
                    scale: .6,
                    child: Checkbox(
                      activeColor: primary,
                      visualDensity: VisualDensity.compact,
                      value: value, // Set the initial value of the checkbox
                      onChanged: (bool? value) {
                        setState(() {
                          this.value = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
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
                    await api.verifyPhoneNumber(
                        context, phone, password.text, email.text);
                  },
                  child: loading
                      ? Container(
                          width: 30,
                          height: 30,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                          ))
                      : const Text(
                          "تسجيل",
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
    );
  }
}
