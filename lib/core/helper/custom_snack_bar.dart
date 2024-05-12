import 'package:flutter/material.dart';
import 'package:sudia_events/core/utils/strings.dart';

CustomSnackBar(BuildContext context, String text, Color color) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      showCloseIcon: true,
      closeIconColor: Colors.white,
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        bottom: mediaheight(context) - 120,
        left: 10,
        right: 10,
      ),
      content: Text(text)));
}
