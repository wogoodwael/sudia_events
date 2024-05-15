import 'package:flutter/material.dart';

class AccountListModel {
   String? title;
   String? subTitle;
  final void Function() ontap;
  final IconData leading;
  final IconData trailing;

  AccountListModel(
      { this.title,
       this.subTitle,
      required this.ontap,
      required this.leading,
      required this.trailing});
}
