import 'package:flutter/material.dart';



InputDecoration inputDecoration(String labelText,Icon icon) {
  return InputDecoration(
    labelText: labelText,
    prefixIcon: icon,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(0.0),
      borderSide: BorderSide(
        width: 2.0,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(0),
      borderSide: BorderSide(color: Colors.blue,width: 2.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(0),
      borderSide: BorderSide(color: Colors.blue,width: 2.0),
    ),
    errorBorder:  OutlineInputBorder(
      borderRadius: BorderRadius.circular(0),
      borderSide: BorderSide(color: Colors.red,width: 2.0),
    ),
  );
}
