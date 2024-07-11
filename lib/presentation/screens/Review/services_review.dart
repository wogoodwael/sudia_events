import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/presentation/screens/Review/give_tips.dart';

class ServiceRatingScreen extends StatefulWidget {
  const ServiceRatingScreen({super.key});

  @override
  State<ServiceRatingScreen> createState() => _ServiceRatingScreenState();
}

class _ServiceRatingScreenState extends State<ServiceRatingScreen> {
  double ratingValue = 1.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('التقيم '),
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
              RatingStars(
                value: ratingValue,
                onValueChanged: (v) {
                  print(v);
                  setState(() {
                    ratingValue = v;
                  });
                  print(ratingValue);
                },
                starBuilder: (index, color) => Icon(
                  Icons.star,
                  color: color,
                  size: 40,
                ),
                starCount: 5,
                starSize: 40,
                valueLabelColor: const Color(0xff9b9b9b),
                valueLabelTextStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 12.0,
                ),
                valueLabelRadius: 10,
                maxValue: 5,
                starSpacing: 2,
                maxValueVisibility: true,
                valueLabelVisibility: true,
                animationDuration: const Duration(milliseconds: 1000),
                valueLabelPadding: const EdgeInsets.symmetric(
                  vertical: 1,
                  horizontal: 8,
                ),
                valueLabelMargin: const EdgeInsets.only(right: 8),
                starOffColor: const Color(0xffe7e8ea),
                starColor: const Color.fromARGB(255, 240, 173, 78),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: mediawidth(context),
                height: 90,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(.2),
                    borderRadius: BorderRadius.circular(10)),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(10),
                            hintText: 'اكتب رايك',
                            hintStyle: GoogleFonts.roboto(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                            border: InputBorder.none),
                      ),
                      const Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.camera_alt,
                                size: 20,
                                color: Colors.grey,
                              ),
                              Icon(
                                Icons.photo,
                                size: 20,
                                color: Colors.grey,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              MaterialButton(
                minWidth: .8 * mediawidth(context),
                height: 40,
                color: primary,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const GivingTipsScreen()));
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
