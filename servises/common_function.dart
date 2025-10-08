import 'package:billfold/settings/contextextension.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget circleLoader(BuildContext context) {
  return Center(
    child: CircularProgressIndicator(
        color: context.watchtheme.currentTheme.scaffoldBackgroundColor,
        backgroundColor: context.watchtheme.currentTheme.primaryColor),
  );
}


String commaSepartor(num value, {int digit = 1}) {
  NumberFormat numberFormat = NumberFormat.decimalPattern('en_IN');
  return numberFormat.format(num.parse(value.toStringAsFixed(digit)));
}