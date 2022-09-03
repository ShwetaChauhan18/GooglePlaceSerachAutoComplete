import 'package:flutter/material.dart';

import '../values/app_colors.dart';

extension ContextExtension on BuildContext {
  void showSnackBar(String message) => ScaffoldMessenger.of(this)
    ..removeCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        backgroundColor: AppColors.colorPrimary,
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
}
