import 'package:flutter/material.dart';

class AppSizedBox {
  static SizedBox height(BuildContext context, double ratio) =>
      SizedBox(height: MediaQuery.of(context).size.height * ratio);

  static SizedBox width(BuildContext context, double ratio) =>
      SizedBox(width: MediaQuery.of(context).size.width * ratio);

  // Common height variations
  static Widget h2 = const SizedBox(height: 2);
  static Widget h4 = const SizedBox(height: 4);
  static Widget h8 = const SizedBox(height: 8);
  static Widget h12 = const SizedBox(height: 12);
  static Widget h16 = const SizedBox(height: 16);
  static Widget h20 = const SizedBox(height: 20);
  static Widget h24 = const SizedBox(height: 24);
  static Widget h32 = const SizedBox(height: 32);
  static Widget h40 = const SizedBox(height: 40);
  static Widget h48 = const SizedBox(height: 48);
  static Widget h56 = const SizedBox(height: 56);
  static Widget h64 = const SizedBox(height: 64);

  // Common width variations
  static Widget w2 = const SizedBox(width: 2);
  static Widget w4 = const SizedBox(width: 4);
  static Widget w8 = const SizedBox(width: 8);
  static Widget w12 = const SizedBox(width: 12);
  static Widget w16 = const SizedBox(width: 16);
  static Widget w20 = const SizedBox(width: 20);
  static Widget w24 = const SizedBox(width: 24);
  static Widget w32 = const SizedBox(width: 32);
  static Widget w40 = const SizedBox(width: 40);
  static Widget w48 = const SizedBox(width: 48);
  static Widget w56 = const SizedBox(width: 56);
  static Widget w64 = const SizedBox(width: 64);

  // Shrink widget (SizedBox.shrink())
  static Widget shrink = const SizedBox.shrink();
}
