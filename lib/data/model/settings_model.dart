import 'package:flutter/material.dart';

class SettingsModel {
  final String title;
  final String subTitle;
  final void Function() ontap;
  final IconData leading;
  final IconData trailing;

  SettingsModel(
      {required this.title, required this.subTitle, required this.ontap, required this.leading, required this.trailing});
}