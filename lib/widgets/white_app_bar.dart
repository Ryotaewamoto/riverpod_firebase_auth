import 'package:flutter/material.dart';

import '../utils/constants/app_colors.dart';
import '../utils/text_styles.dart';

/// Original [AppBar].
class WhiteAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WhiteAppBar({
    super.key,
    required this.title,
    this.automaticallyImplyLeading = false,
    this.leading,
    this.elevation = 1,
    this.actions,
  });

  final String title;
  final bool automaticallyImplyLeading;
  final Widget? leading;
  final double elevation;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(48);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading,
      centerTitle: true,
      elevation: elevation,
      title: Text(
        title,
        style: TextStyles.h3(),
      ),
      backgroundColor: AppColors.baseWhite,
      iconTheme: const IconThemeData(color: AppColors.primary),
      actions: actions,
    );
  }
}
