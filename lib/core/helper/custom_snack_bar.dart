import 'package:flutter/material.dart';

CustomSnackBar(BuildContext context, String text, Color color, double bottom) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      showCloseIcon: true,
      closeIconColor: Colors.white,
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        bottom:bottom,
        left: 10,
        right: 10,
      ),
      content: Text(text)));
}
