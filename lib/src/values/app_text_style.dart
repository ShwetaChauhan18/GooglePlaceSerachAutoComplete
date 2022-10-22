import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle textRobotoBold = TextStyle(
    color: AppColors.textColor,
    fontWeight: FontWeight.bold,
    fontFamily: 'Roboto',
    fontSize: 17.0,
  );

  static const TextStyle textRobotoRegular = TextStyle(
    color: AppColors.textColor,
    fontWeight: FontWeight.w200,
    fontFamily: 'Roboto',
    fontSize: 16.0,
    height: 1.35,
  );
}
