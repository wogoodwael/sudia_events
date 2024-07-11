import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/main.dart';
import 'package:sudia_events/presentation/screens/buttom_bar.dart';

class GivingTipsScreen extends StatefulWidget {
  const GivingTipsScreen({super.key});

  @override
  State<GivingTipsScreen> createState() => _GivingTipsScreenState();
}

class _GivingTipsScreenState extends State<GivingTipsScreen> {
  List<bool> ontap = [false, false, false, false, false, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' المكافات'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text("مقدم الخدمة"),
              const SizedBox(
                height: 20,
              ),
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(
                    'assets/images/person.png'), // Replace with your image asset
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'جمعان الزهراني ',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(height: 16),
              Column(
                children: List.generate(
                    2,
                    (index) => Row(
                          children: List.generate(4, (index2) {
                            int combinedIndex = index * 4 + index2;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  ontap[combinedIndex] = !ontap[combinedIndex];
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.all(5),
                                width: 70,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: ontap[combinedIndex]
                                        ? Colors.yellow
                                        : Colors.white,
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Center(
                                  child: Text(
                                    "SAR 10",
                                    style: TextStyle(color: primary),
                                  ),
                                ),
                              ),
                            );
                          }),
                        )),
              ),
              const SizedBox(height: 16),
              MaterialButton(
                minWidth: .8 * mediawidth(context),
                height: 40,
                color: primary,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset("assets/images/heart.png"),
                            const Text(
                              "شكراً لك ..",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                            const Text(
                              " نقدر وقتك ونسعد بخدمتك مرة أخرى قريبًا!",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 16),
                            ),
                            const Text(
                              "حصلت علي  ١٠٠ نقطة في محفظتك",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 12),
                            )
                          ],
                        ),
                        actions: [
                          Center(
                            child: MaterialButton(
                              color: primary,
                              minWidth: .8 * mediawidth(context),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => BottomBarScreen(
                                            id: sharedpref.getString(
                                                'token')!))); // Close the dialog
                              },
                              child: const Text(
                                "ok",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  );
                },
                child: Text(
                  'التالي',
                  style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  // Your onPressed logic
                },
                child: const Text('إلغاء'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
