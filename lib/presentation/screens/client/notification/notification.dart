import 'package:flutter/material.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/presentation/screens/client/notification/offers_container.dart';
import 'package:sudia_events/presentation/screens/client/notification/custom_container.dart';

class NotificationBody extends StatelessWidget {
  const NotificationBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Expanded(
        flex: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Stack(
              children: [
                CustomContainer(),
                Positioned(
                  top: -2,
                  left: 40,
                  child: Icon(
                    Icons.bookmark,
                    color: primary,
                    size: 20,
                  ),
                ),
              ],
            ),
            Divider(
              height: 70,
              endIndent: 20,
              indent: 20,
              color: primary,
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: FittedBox(
                child: Text(
                  "خدمات معروضة  ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
            Stack(
              children: [
                OffersContainer(),
                Positioned(
                  top: -0,
                  left: 70,
                  child: Icon(
                    Icons.bookmark,
                    color: primary,
                    size: 20,
                  ),
                ),
                Positioned(
                    top: 10,
                    left: 20,
                    child: FittedBox(
                      child: Text(
                        "مشاهدة",
                        style: TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    )),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Stack(
              children: [
                OffersContainer(),
                Positioned(
                  top: -0,
                  left: 70,
                  child: Icon(
                    Icons.bookmark,
                    color: primary,
                    size: 20,
                  ),
                ),
                Positioned(
                    top: 10,
                    left: 20,
                    child: FittedBox(
                      child: Text(
                        "مشاهدة",
                        style: TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    )),
              ],
            ),
          ],
        ));
  }
}
