
import 'package:flutter/material.dart';

class NavigationHelper {
  static push({required BuildContext context, required Widget targetClass}) =>
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => targetClass,
          ));

  static pushReplacement(
      {required BuildContext context, required Widget targetClass}) =>
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => targetClass,
          ));

  static pop(BuildContext context) => Navigator.pop(context);
}
