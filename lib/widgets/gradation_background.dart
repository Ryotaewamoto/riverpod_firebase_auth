import 'package:flutter/material.dart';

import '/utils/constants/app_colors.dart';

/// グラデーションをつけた背景の [Widget]
class GradationBackground extends StatelessWidget {
  const GradationBackground({this.startPoint = 0.80, super.key});

  final double startPoint;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            stops: [
              startPoint,
              1.0,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: const <Color>[
              AppColors.baseWhite,
              AppColors.primary,
            ],
          ),
        ),
      ),
    );
  }
}
