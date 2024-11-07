import 'package:flutter/material.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/presentation/screens/client/notification/widgets/build_offer_container.dart';
import 'package:sudia_events/presentation/screens/client/notification/widgets/custom_container.dart';

class NotificationBody extends StatelessWidget {
  const NotificationBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Stack(
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
        const Divider(
          height: 70,
          color: primary,
          endIndent: 20,
          indent: 20,
        ),
        const SizedBox(height: 5),
        const Padding(
          padding: EdgeInsets.only(right: 20),
          child: FittedBox(
            child: Text(
              "خدمات معروضة  ",
              style: TextStyle(fontFamily: 'JF',fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ),
        buildOffersContainer(),
        const SizedBox(height: 5),
        buildOffersContainer(),
      ],
    );
  }

}
