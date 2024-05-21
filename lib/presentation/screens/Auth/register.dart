import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudia_events/core/helper/language_provider.dart';
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
  bool remember = false;
  Api api = Api();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (BuildContext context, LanguageProvider value, Widget? child) {
        return Expanded(
          flex: 17,
          child: Container(
            width: .9 * mediawidth(context),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 13.0, bottom: 5, top: 10),
                    child: Text(
                      "name".tr(),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                          keyboardType: TextInputType.name,
                          // textDirection: value.textDirection,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'name'.tr(),
                            hintStyle: TextStyle(color: Colors.grey[300]),
                            // hintTextDirection: value.textDirection,
                            prefixIcon: Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, bottom: 4),
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

                    child: Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Text(
                        "phone".tr(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
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
                          // textDirection: value.textDirection,
                          keyboardType: TextInputType.phone,
                          controller: phone,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText:
                                '513245458                                    966',
                            hintStyle: TextStyle(color: Colors.grey[300]),
                            // hintTextDirection: value.textDirection,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 13.0, bottom: 10),
                    child: Text(
                      "email".tr(),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                          // textDirection: value.textDirection,
                          keyboardType: TextInputType.emailAddress,
                          controller: email,
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, bottom: 4),
                                child: Icon(
                                  Icons.email,
                                  color: Colors.grey,
                                )),
                            border: InputBorder.none,
                            hintText: 'email'.tr(),
                            hintStyle: TextStyle(color: Colors.grey[300]),
                            // hintTextDirection: value.textDirection,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Transform.scale(
                        scale: .6,
                        child: Checkbox(
                          activeColor: primary,
                          visualDensity: VisualDensity.compact,
                          value:
                              remember, // Set the initial value of the checkbox
                          onChanged: (bool? value) {
                            setState(() {
                              remember = value!;
                            });
                          },
                        ),
                      ),
                      Text(
                        'remember'.tr(),
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold),
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
                      color: remember ? primary : secondary,
                      minWidth: 300,
                      onPressed: () async {
                        api.verifyPhoneNumber(
                            context, phone, email.text, loading, (bool value) {
                          setState(() {
                            loading = value;
                          });
                        });
                      },
                      child: loading
                          ? Container(
                              width: 30,
                              height: 30,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                              ))
                          : Text(
                              "signup".tr(),
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
      },
    );
  }
}
