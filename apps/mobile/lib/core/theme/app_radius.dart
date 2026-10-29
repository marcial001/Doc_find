import 'package:flutter/material.dart';

abstract final class AppRadius {
  static const double smValue = 8;
  static const double mdValue = 12;
  static const double buttonValue = 14;
  static const double cardValue = 18;
  static const double sheetValue = 26;
  static const double pillValue = 999;

  static const Radius smRadius = Radius.circular(smValue);
  static const Radius mdRadius = Radius.circular(mdValue);
  static const Radius buttonRadius = Radius.circular(buttonValue);
  static const Radius cardRadius = Radius.circular(cardValue);
  static const Radius sheetRadius = Radius.circular(sheetValue);

  static const BorderRadius sm = BorderRadius.all(smRadius);
  static const BorderRadius md = BorderRadius.all(mdRadius);
  static const BorderRadius button = BorderRadius.all(buttonRadius);
  static const BorderRadius card = BorderRadius.all(cardRadius);
  static const BorderRadius sheet = BorderRadius.vertical(top: sheetRadius);
  static const BorderRadius pill = BorderRadius.all(Radius.circular(pillValue));
}
