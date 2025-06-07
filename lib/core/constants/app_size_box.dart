import 'package:flutter/material.dart';

class AppSizedBox {
  static SizedBox height(BuildContext context, double ratio) =>
      SizedBox(height: MediaQuery.of(context).size.height * ratio);

  static SizedBox width(BuildContext context, double ratio) =>
      SizedBox(width: MediaQuery.of(context).size.width * ratio);
}
