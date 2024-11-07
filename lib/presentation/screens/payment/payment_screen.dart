import 'package:flutter/material.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/presentation/screens/positioned_logo.dart';

class PayMentScreen extends StatefulWidget {
  const PayMentScreen({super.key});

  @override
  State<PayMentScreen> createState() => _PayMentScreenState();
}

class _PayMentScreenState extends State<PayMentScreen> {
  bool pay = false;
  String _selectedPaymentMethod = 'tamara';
  bool _savePaymentMethod = false;

  bool compelet = false;

  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
              flex: 1,
              child: Container(
                child: Stack(children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Container(
                      height: 150,
                      width: 400,
                      decoration: const BoxDecoration(
                        color: primary,
                      ),
                    ),
                  ),
                  const PositionedLogo(),
                  Positioned(
                      right: .02 * mediawidth(context),
                      top: .06 * mediaheight(context),
                      child: Transform.scale(
                        scale: 1.2,
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      )),
                  Positioned(
                    bottom: 0,
                    left: 20,
                    top: .12 * mediaheight(context),
                    child: Container(
                      width: .9 * mediawidth(context),
                      height: 50,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            "3",
                            style: TextStyle(fontFamily: 'JF',
                                color: primary,
                                fontSize: 35,
                                fontWeight: FontWeight.bold),
                          ),
                          Text("عدد الخدمات ",
                              style: TextStyle(fontFamily: 'JF',
                                  color: Colors.grey[800], fontSize: 25)),
                        ],
                      ),
                    ),
                  )
                ]),
              )),
          Expanded(
              flex: 3,
              child: Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              pay = true;
                              compelet = false;
                            });
                          },
                          child: Container(
                            width: 130,
                            height: 40,
                            decoration: BoxDecoration(
                              color: pay ? primary : Colors.white,
                              border: !pay
                                  ? Border.all(color: primary)
                                  : Border.all(color: Colors.white),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "دفع كامل الفاتورة",
                                style: TextStyle(fontFamily: 'JF',
                                  color: pay ? Colors.white : primary,
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
                              pay = false;
                              compelet = true;
                            });
                          },
                          child: Container(
                            width: 130,
                            height: 40,
                            decoration: BoxDecoration(
                              border: !compelet
                                  ? Border.all(color: primary)
                                  : Border.all(color: Colors.white),
                              color: compelet ? primary : Colors.white,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "لاتمام الحجز",
                                style: TextStyle(fontFamily: 'JF',
                                  color: compelet ? Colors.white : primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: mediawidth(context),
                            height: .3 * mediaheight(context),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: primary, width: 0)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    _buildRadioOption('stcpay'),
                                    SizedBox(
                                      width: .3 * mediawidth(context),
                                    ),
                                    _buildRadioOption('applepay'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    _buildRadioOption('paypal'),
                                    SizedBox(
                                      width: .3 * mediawidth(context),
                                    ),
                                    _buildRadioOption('mada'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    _buildRadioOption('visa_mastercard'),
                                    SizedBox(
                                      width: .3 * mediawidth(context),
                                    ),
                                    _buildRadioOption('bank_transfer'),
                                  ],
                                ),
                                const Divider(
                                  endIndent: 20,
                                  indent: 30,
                                  color: primary,
                                  thickness: 0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    _buildRadioOption('tabby'),
                                    SizedBox(
                                      width: .3 * mediawidth(context),
                                    ),
                                    _buildRadioOption('tamara'),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              const Text(
                                'احفظ طريقة الدفع',
                                style: TextStyle(fontFamily: 'JF',color: Colors.grey),
                              ),
                              Transform.scale(
                                scale: .7,
                                child: Checkbox(
                                  value: _savePaymentMethod,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _savePaymentMethod = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    compelet
                        ? Stack(
                            children: [
                              Container(
                                width: .85 * mediawidth(context),
                                height: .12 * mediaheight(context),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color(0xffb3dfdd)),
                              ),
                              Positioned(
                                bottom: .07 * mediaheight(context),
                                right: 0,
                                child: Transform.scale(
                                  scale: .5,
                                  child: Checkbox(
                                    value: _isChecked,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _isChecked = value!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: .09 * mediaheight(context),
                                right: .09 * mediawidth(context),
                                child: const Text(
                                  '''عدم اكمال 3000 قبل يوم 17/8/2020 تلغي الحجوزات''',
                                  style: TextStyle(fontFamily: 'JF',
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Positioned(
                                right: .07 * mediawidth(context),
                                top: .03 * mediaheight(context),
                                child: const Padding(
                                  padding: EdgeInsets.only(bottom: 10.0),
                                  child: Text(
                                    'تطبق الأحكام والشروط',
                                    style: TextStyle(fontFamily: 'JF',
                                      fontSize: 10,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ),
                              Positioned(
                                  bottom: 0 * mediaheight(context),
                                  child: Container(
                                    width: .85 * mediawidth(context),
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: primary),
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: 5.0),
                                              child: Text(
                                                'SR',
                                                style: TextStyle(fontFamily: 'JF',
                                                    fontSize: 10,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            Text(
                                              "1300",
                                              style: TextStyle(fontFamily: 'JF',
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "ادفع الان ",
                                          style: TextStyle(fontFamily: 'JF',
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ))
                            ],
                          )
                        : SizedBox(
                            width: .8 * mediawidth(context),
                            child: MaterialButton(
                              color: primary,
                              minWidth: .7 * mediawidth(context),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              onPressed: () {},
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.only(top: 5.0),
                                        child: Text(
                                          'SR',
                                          style: TextStyle(fontFamily: 'JF',
                                              fontSize: 10,
                                              color: Colors.white),
                                        ),
                                      ),
                                      Text(
                                        "4300",
                                        style: TextStyle(fontFamily: 'JF',
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "ادفع الان ",
                                    style: TextStyle(fontFamily: 'JF',
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          )
                  ],
                ),
              ))
        ],
      ),
    );
  }

  Widget _buildRadioOption(String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Image.asset(
          'assets/images/$value.png',
          width: 40.0,
          fit: BoxFit.cover,
        ),
        Transform.scale(
          scale: .7,
          child: Radio<String>(
            activeColor: primary,
            value: value,
            groupValue: _selectedPaymentMethod,
            onChanged: (String? newValue) {
              setState(() {
                _selectedPaymentMethod = newValue!;
              });
            },
          ),
        ),
      ],
    );
  }
}
