import 'package:flutter/material.dart';

import '../utils/constants/app_colors.dart';
import '../utils/text_styles.dart';

/// The header [Widget] of setting on [TextFormField].
class TextFormHeader extends StatelessWidget {
  const TextFormHeader({
    required this.title,
    this.color = AppColors.baseBlack,
    super.key,
  });

  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(title, style: TextStyles.h4(color: color)),
    );
  }
}
