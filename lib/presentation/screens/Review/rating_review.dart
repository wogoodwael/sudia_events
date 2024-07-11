import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';
import 'package:sudia_events/presentation/screens/Review/services_review.dart';

class RatingReviewScreen extends StatefulWidget {
  final List orders;
  final List images;
  final List texts;

  const RatingReviewScreen(
      {super.key,
      required this.orders,
      required this.images,
      required this.texts});

  @override
  State<RatingReviewScreen> createState() => _RatingReviewScreenState();
}

class _RatingReviewScreenState extends State<RatingReviewScreen> {
  double ratingValue = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('قيم الطلبات'),
      ),
      body: ListView.builder(
        itemCount: widget.orders.length, // Adjust based on your data
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                leading: SizedBox(
                  width: 90,
                  height: 200,
                  child: Image.network(widget.images[index] ?? ""),
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.texts[index] ?? "قاعة غيم"),
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
                        size: 30,
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
                      valueLabelRadius: 5,
                      maxValue: 5,
                      starSpacing: 2,
                      maxValueVisibility: false,
                      valueLabelVisibility: false,
                      animationDuration: const Duration(milliseconds: 1000),
                      starOffColor: const Color(0xffe7e8ea),
                      starColor: const Color.fromARGB(255, 240, 173, 78),
                    ),
                  ],
                ),
              ),
              Center(
                child: Container(
                  width: .9 * mediawidth(context),
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
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: MaterialButton(
          color: primary,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => ServiceRatingScreen()));
          },
          child: const Text(
            'التالي',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
