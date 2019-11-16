import 'package:flutter/material.dart';
import 'package:tour_guide_rental/helpers/colors.dart';

FlatButton froyoFlatBtn(String text, onPressed) {
  return FlatButton(
    onPressed: onPressed,
    child: Text(text),
    textColor: white,
    color: primaryColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
  );
}

FlatButton froyoFlatBtnCancel(String text, onPressed) {
  return FlatButton(
    onPressed: onPressed,
    child: Text(text),
    textColor: white,
    color: Colors.red,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
  );
}

OutlineButton froyoOutlineBtn(String text, onPressed) {
  return OutlineButton(
    onPressed: onPressed,
    child: Text(text),
    textColor: primaryColor,
    highlightedBorderColor: highlightColor,
    borderSide: BorderSide(color: primaryColor),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
  );
}

FloatingActionButton floatingActionButton(onPressed) {
  return FloatingActionButton(
    onPressed: onPressed,
    tooltip: 'Date Birth',
    child: Icon(Icons.date_range),
  );
}
