import 'package:flutter/material.dart';

AppBar buildAppBar(String titleText) {
  return AppBar(
    title: Text(titleText),
    backgroundColor: Colors.grey,
    centerTitle: true,
  );
}
