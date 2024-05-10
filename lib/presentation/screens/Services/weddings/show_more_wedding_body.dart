import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/core/utils/strings.dart';

class ShowMoreWeddingBody extends StatefulWidget {
  const ShowMoreWeddingBody(
      {super.key,
      required this.showMore,
      required this.pageController,
      required this.currentPage,
      required this.imagePaths, required this.onPressed});
  final bool showMore;
  final PageController pageController;
  final int currentPage;
  final List<String> imagePaths;
  final void Function() onPressed;
  @override
  State<ShowMoreWeddingBody> createState() => _ShowMoreWeddingBodyState();
}

class _ShowMoreWeddingBodyState extends State<ShowMoreWeddingBody> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: .5 * mediaheight(context),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (widget.currentPage > 0) {
                      widget.pageController.previousPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.ease);
                    }
                  },
                ),
                SizedBox(
                  width: .4 * mediawidth(context),
                ),
                IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (widget.currentPage < widget.imagePaths.length - 1) {
                      widget.pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.ease);
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: .25 * mediaheight(context)),
            Container(
              width: MediaQuery.of(context).size.width,
              height: .4 * MediaQuery.of(context).size.height,
              color: Colors.black.withOpacity(0.4),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "السعر",
                                style: TextStyle(color: Colors.white),
                              ),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Text(
                                      'SR',
                                      style: TextStyle(
                                          fontSize: 17, color: primary),
                                    ),
                                  ),
                                  Text(
                                    "5000",
                                    style: TextStyle(
                                        color: primary,
                                        fontSize: 35,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "قاعة غيم",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 30),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "جدة - حي الشاطئ",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                                Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              ],
                            ),
                            Text(
                              "نبذة عن القصر ومواصفات القصر  وو",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 10),
                            )
                          ],
                        ),
                      ],
                    ),
                    Center(
                      child: MaterialButton(
                        minWidth: .7 * MediaQuery.of(context).size.width,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: primary,
                        onPressed: widget.onPressed,
                        child: Text(
                          "احجز الان",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
