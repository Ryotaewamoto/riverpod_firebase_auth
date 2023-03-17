import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'constants/app_colors.dart';

/// アプリ全体に半透明のローディング画面を重ねるかどうか。
final overlayLoadingProvider =
    NotifierProvider<_LoadingNotifier, bool>(() => _LoadingNotifier());

class _LoadingNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void startLoading() => state = true;

  void endLoading() => state = false;
}

/// プライマリカラーの SpinkitCircle を表示する
class PrimarySpinkitCircle extends StatelessWidget {
  const PrimarySpinkitCircle({
    super.key,
    this.size = 48,
  });

  final double size;
  @override
  Widget build(BuildContext context) {
    return SpinKitFadingCircle(
      size: size,
      color: AppColors.primary,
    );
  }
}

/// 二度押しを防止したいときなどの重ねるローディングウィジェット
class OverlayLoadingWidget extends StatelessWidget {
  const OverlayLoadingWidget({
    super.key,
    this.backgroundColor = AppColors.baseLight,
  });

  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundColor.withOpacity(0.7),
      child: const SizedBox.expand(
        child: Center(
          child: PrimarySpinkitCircle(),
        ),
      ),
    );
  }
}
