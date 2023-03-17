import 'package:flutter/material.dart';

import '../utils/constants/app_colors.dart';

/// In the case of Android, this [Widget] gives app colors to
/// the effected of shrinking [SingleChildScrollView].
class AppOverScrollIndicator extends StatelessWidget {
  const AppOverScrollIndicator({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GlowingOverscrollIndicator(
      axisDirection: AxisDirection.down,
      color: AppColors.secondary,
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification notification) {
          notification.disallowIndicator(); // call disallowGlow().
          return false;
        },
        child: child,
      ),
    );
  }
}
