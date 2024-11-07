import 'package:easy_localization/easy_localization.dart' as easy;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:sudia_events/core/helper/appBar.dart';
import 'package:sudia_events/core/helper/language_provider.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/data/services/api.dart';
import 'package:sudia_events/main.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool visable = false;
  bool remember = false;
  Api api = Api();
  TextEditingController phoneE = TextEditingController();
  TextEditingController name = TextEditingController();

  TextEditingController email = TextEditingController();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar("التسجيل", context),
      body: Column(
        children: [
          Consumer<LanguageProvider>(
            builder:
                (BuildContext context, LanguageProvider value, Widget? child) {
              return Expanded(
                flex: 5,
                child: SizedBox(
                  width: .9 * mediawidth(context),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: IntlPhoneField(
                              keyboardType: const TextInputType.numberWithOptions(),
                              controller: phoneE,
                              onSubmitted: (p0) {
                                setState(() {
                                  phoneE;
                                });
                              },
                              dropdownIcon:
                                  const Icon(Icons.keyboard_arrow_down_rounded),
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(
                                  top: 12,
                                ),
                                border: InputBorder.none,
                                counterText: "",
                                errorStyle: TextStyle(
                                    fontFamily: 'JF',
                                    fontSize: 0,
                                    height: 0), // This hides the error text
                              ),
                              initialCountryCode: 'AE',
                              onChanged: (phone) {
                                print(phone.completeNumber);
                                sharedpref.setString(
                                    'phone', phone.completeNumber);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              keyboardType: TextInputType.name,
                              controller: name,
                              // textDirection: value.textDirection,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'name'.tr(),
                                hintStyle: const TextStyle(
                                    fontFamily: 'JF', color: Colors.grey),
                                // hintTextDirection: value.textDirection,
                                prefixIcon: const Padding(
                                    padding:
                                        EdgeInsets.only(left: 8, bottom: 4),
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.grey,
                                    )),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              keyboardType: TextInputType.name,
                              controller: email,
                              // textDirection: value.textDirection,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'email'.tr(),
                                hintStyle: const TextStyle(
                                    fontFamily: 'JF', color: Colors.grey),
                                // hintTextDirection: value.textDirection,
                                prefixIcon: const Padding(
                                    padding:
                                        EdgeInsets.only(left: 8, bottom: 4),
                                    child: Icon(
                                      Icons.email,
                                      color: Colors.grey,
                                    )),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
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
                              style: const TextStyle(
                                  fontFamily: 'JF',
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "شروط الخدمة",
                        style: GoogleFonts.roboto(
                            color: primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Text(
                        " و ",
                        style: GoogleFonts.roboto(
                            fontSize: 12, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Text(
                        "سياسة الخصوصية",
                        style: GoogleFonts.roboto(
                            color: primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        "اقبل",
                        style: GoogleFonts.roboto(
                            fontSize: 12, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  Center(
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: phoneE.text.isNotEmpty ? primary : secondary,
                      minWidth: 300,
                      onPressed: () async {
                        api.verifyPhoneNumber(
                            context, phoneE, email.text, loading, (bool value) {
                          setState(() {
                            loading = value;
                          });
                        }, name.text);
                      },
                      child: loading
                          ? const SizedBox(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ))
                          : Text(
                              "register".tr(),
                              style: const TextStyle(
                                  fontFamily: 'JF',
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
        ],
      ),
    );
  }
}
