import 'package:flutter/material.dart';

import '../features/notifiers/is_obscure_notifier.dart';
import 'constants/app_colors.dart';

/// [TextFormField] arguments, i.e., the form styles of [InputDecoration].
class AppTextFormStyles {
  AppTextFormStyles();

  static InputDecoration onGeneral({
    required IconData iconData,
    Color color = AppColors.baseLight,
  }) =>
      InputDecoration(
        contentPadding: EdgeInsets.zero,
        prefixIcon: Icon(
          iconData,
          color: color,
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.secondaryPale,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: color,
          ),
        ),
      );

  static InputDecoration onPassword({
    required bool state,
    required IsObscureNotifier notifier,
  }) =>
      InputDecoration(
        contentPadding: EdgeInsets.zero,
        prefixIcon: const Icon(
          Icons.lock,
          color: AppColors.baseLight,
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.secondaryPale,
            width: 2,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.baseLight,
          ),
        ),
        suffixIcon: state
            ? IconButton(
                icon: const Icon(
                  Icons.visibility_off,
                  color: AppColors.baseLight,
                ),
                onPressed: () {
                  notifier.toUnobscured();
                },
              )
            : IconButton(
                icon: const Icon(
                  Icons.visibility,
                  color: AppColors.baseLight,
                ),
                onPressed: () {
                  notifier.toObscured();
                },
              ),
      );
}
