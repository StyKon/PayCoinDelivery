import 'package:flutter/material.dart';
import '../Helper/color.dart';

setSnackbar(String msg, context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        msg,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: white,
        ),
      ),
      duration: const Duration(
        seconds: 2,
      ),
      backgroundColor: fontColor,
      elevation: 1.0,
    ),
  );
}
