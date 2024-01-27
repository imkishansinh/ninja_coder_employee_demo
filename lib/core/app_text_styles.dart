import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle appBarTextStyle = TextStyle(
    fontFamily: "Roboto",
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    height: 21 / 18,
  );

  static const TextStyle textField = TextStyle(
    fontFamily: "Roboto",
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textFieldTextColor,
    height: 21 / 16,
  );

  static const TextStyle listTileTitle = TextStyle(
    fontFamily: "Roboto",
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.listTileTitleColor,
    height: 21 / 16,
  );

  static const TextStyle listTileSubTitle = TextStyle(
    fontFamily: "Roboto",
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.listTileSubTitleColor,
    height: 21 / 14,
  );

  static const TextStyle listTileSubDesc = TextStyle(
    fontFamily: "Roboto",
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.listTileDescColor,
    height: 21 / 12,
  );

  static const TextStyle stickyHeader = TextStyle(
    fontFamily: "Roboto",
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryColor,
    height: 21 / 16,
  );

  static const TextStyle calendarTitle = TextStyle(
    fontFamily: 'Roboto',
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.listTileTitleColor,
    height: 21 / 18,
  );

  static const TextStyle selectedDateTextStyle = TextStyle(
    fontFamily: "Roboto",
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textFieldTextColor,
    height: 20 / 16,
  );

  static const TextStyle calendarDateText = TextStyle(
    fontFamily: "Roboto",
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textFieldTextColor,
    height: 20 / 15,
  );
}
