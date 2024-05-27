import 'package:flutter/material.dart';
import 'package:sudia_events/core/utils/strings.dart';

class SearchContainernew extends StatelessWidget {
  SearchContainernew({super.key, required this.hintText});
  TextEditingController controller = TextEditingController();
  final String hintText;

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
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.grey[400],
            ),
            suffixIcon: Icon(
              Icons.tune,
              color: Colors.grey[400],
            )),
      ),
    );
  }
}
