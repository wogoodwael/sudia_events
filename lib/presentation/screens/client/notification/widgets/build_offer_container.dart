  import 'package:flutter/material.dart';
import 'package:sudia_events/core/utils/constants.dart';
import 'package:sudia_events/presentation/screens/client/notification/offers_container.dart';

Widget buildOffersContainer() {
    return const Stack(
      children: [
        OffersContainer(),
        Positioned(
          top: 0,
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
              style: TextStyle(fontFamily: 'JF',color: Colors.red, fontSize: 13),
            ),
          ),
        ),
      ],
    );
  }
