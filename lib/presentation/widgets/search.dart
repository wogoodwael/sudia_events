import 'package:flutter/material.dart';
import 'package:sudia_events/core/utils/strings.dart';

class SearchContainernew extends StatelessWidget {
  const SearchContainernew(
      {super.key, required this.hintText, required this.controller, required this.onTap});
  final TextEditingController controller;
  final String hintText;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: .9 * mediawidth(context),
      height: 45,
      decoration: BoxDecoration(color: Colors.grey[200]),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(fontFamily: 'JF',color: Colors.grey[400]),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.grey[400],
            ),
            suffixIcon: GestureDetector(
              onTap: onTap,
              child: Icon(
                Icons.tune,
                color: Colors.grey[400],
              ),
            )),
      ),
    );
  }
}
