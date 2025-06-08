import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const String _fontFamily = 'Cera Pro';

  static TextStyle _base(double width,
      {required double size,
        required FontWeight weight,
        required Color color}) {
    return TextStyle(
      fontFamily: _fontFamily,
      fontSize: width * size,
      fontWeight: weight,
      color: color,
    );
  }

  static TextStyle _headerStyle(double width) =>
      _base(width, size: 0.06, weight: FontWeight.w500, color: AppColors.textDark);

  static TextStyle _dialogActionStyle(double width, Color color) =>
      _base(width, size: 0.04, weight: FontWeight.w500, color: color);

  static TextStyle _smallText(double width, Color color) =>
      _base(width, size: 0.035, weight: FontWeight.w400, color: color);



  static TextStyle headerConversation(BuildContext context) =>
      _headerStyle(MediaQuery.of(context).size.width);

  static TextStyle headerSuggestion(BuildContext context) =>
      _headerStyle(MediaQuery.of(context).size.width);

  static TextStyle bodySuggestion(BuildContext context) =>
      _base(MediaQuery.of(context).size.width,
          size: 0.045, weight: FontWeight.w400, color: AppColors.textDark);

  static TextStyle bodyLight(BuildContext context) =>
      _base(MediaQuery.of(context).size.width,
          size: 0.04, weight: FontWeight.w400, color: AppColors.textLight);

  static TextStyle button(BuildContext context) =>
      _base(MediaQuery.of(context).size.width,
          size: 0.0375, weight: FontWeight.w700, color: AppColors.buttonText);

  static TextStyle caption(BuildContext context) =>
      _base(MediaQuery.of(context).size.width,
          size: 0.03, weight: FontWeight.w300, color: AppColors.textLight);

  static TextStyle chatButton(BuildContext context) =>
      _base(MediaQuery.of(context).size.width,
          size: 0.06, weight: FontWeight.bold, color: AppColors.textDark);

  static TextStyle dialogTitle(BuildContext context) =>
      _base(MediaQuery.of(context).size.width,
          size: 0.05, weight: FontWeight.bold, color: AppColors.textDark);

  static TextStyle dialogButton(BuildContext context) =>
      _dialogActionStyle(MediaQuery.of(context).size.width, AppColors.primary);

  static TextStyle dialogCancelButton(BuildContext context) =>
      _dialogActionStyle(MediaQuery.of(context).size.width, AppColors.textDark);

  static TextStyle dialogDeleteButton(BuildContext context) =>
      _dialogActionStyle(MediaQuery.of(context).size.width, AppColors.iconDelete);

  static TextStyle conversationTitle(BuildContext context) =>
      _base(MediaQuery.of(context).size.width,
          size: 0.04, weight: FontWeight.bold, color: AppColors.textDark);

  static TextStyle conversationMessage(BuildContext context) =>
      _smallText(MediaQuery.of(context).size.width, AppColors.conversatioTextMessage);

  static TextStyle conversationDate(BuildContext context) =>
      _base(MediaQuery.of(context).size.width,
          size: 0.03,
          weight: FontWeight.w400,
          color: AppColors.conversatioDateMessage);

  static TextStyle totalPriceLabel(BuildContext context) =>
      _base(MediaQuery.of(context).size.width,
          size: 0.045, weight: FontWeight.bold, color: AppColors.textDark);

  static TextStyle totalPriceValue(BuildContext context) =>
      _base(MediaQuery.of(context).size.width,
          size: 0.055, weight: FontWeight.bold, color: AppColors.textDark);

  static TextStyle confirmOrderButton(BuildContext context) =>
      _base(MediaQuery.of(context).size.width,
          size: 0.045, weight: FontWeight.bold, color: AppColors.textDark);

  static TextStyle actionButtonText(BuildContext context) =>
      _base(MediaQuery.of(context).size.width,
          size: 0.042, weight: FontWeight.bold, color: AppColors.textDark);

  static TextStyle productCardTitle(BuildContext context) =>
      _base(MediaQuery.of(context).size.width,
          size: 0.05, weight: FontWeight.bold, color: AppColors.textDark);

  static TextStyle productCardBrand(BuildContext context) =>
      _smallText(MediaQuery.of(context).size.width, AppColors.textDark);

  static TextStyle quantityTextField(BuildContext context) =>
      _base(MediaQuery.of(context).size.width,
          size: 0.045, weight: FontWeight.bold, color: AppColors.textDark);

  static TextStyle confirmOrderHeader(BuildContext context) =>
      _base(MediaQuery.of(context).size.width,
          size: 0.07, weight: FontWeight.bold, color: AppColors.textDark);


  static TextStyle screenTitle(BuildContext context) =>
      _base(MediaQuery.of(context).size.width,
          size: 0.06,
          weight: FontWeight.bold,
          color: AppColors.textDark);

}
