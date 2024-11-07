// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';


PreferredSizeWidget CustomAppBar(
    String text, BuildContext context ) {

  return 
 AppBar(
        title:  Text(text, style: const TextStyle(fontFamily: 'JF')),
        centerTitle: true,
        backgroundColor: Colors.white,
    );}