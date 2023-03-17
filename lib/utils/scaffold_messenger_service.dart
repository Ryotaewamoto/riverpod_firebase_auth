import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'async_value_error_dialog.dart';
import 'constants/app_colors.dart';
import 'constants/snack_bar.dart';
import 'text_styles.dart';

final scaffoldMessengerKeyProvider = Provider(
  (_) => GlobalKey<ScaffoldMessengerState>(),
);

final scaffoldMessengerServiceProvider =
    Provider.autoDispose(ScaffoldMessengerService.new);

/// ツリー上部の ScaffoldMessenger 上でスナックバーやダイアログの表示を操作する。
/// Operate showing dialog or snackbar
/// on ScaffoldMessenger set on the above of tree.
class ScaffoldMessengerService {
  ScaffoldMessengerService(this._ref);

  final AutoDisposeProviderRef<ScaffoldMessengerService> _ref;

  GlobalKey<ScaffoldMessengerState> get scaffoldMessengerKey =>
      _ref.read(scaffoldMessengerKeyProvider);

  /// showDialog で指定したビルダー関数を返す。
  /// Return builder function of showDialog
  ///
  /// エラーに関しては別で [AsyncValueErrorDialog] を用いて対応する。
  /// Error handling depends on using [AsyncValueErrorDialog].
  Future<T?> showDialogByBuilder<T>({
    required Widget Function(BuildContext) builder,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: scaffoldMessengerKey.currentContext!,
      barrierDismissible: barrierDismissible,
      builder: builder,
    );
  }

  /// スナックバーを表示する。
  /// Show a snackbar.
  ///
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
    String message, {
    bool removeCurrentSnackBar = true,
    Duration duration = defaultSnackBarDuration,
  }) {
    final scaffoldMessengerState = scaffoldMessengerKey.currentState!;
    if (removeCurrentSnackBar) {
      scaffoldMessengerState.removeCurrentSnackBar();
    }
    return scaffoldMessengerState.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyles.p2(color: AppColors.baseWhite),
        ),
        backgroundColor: AppColors.baseBlack,
        behavior: defaultSnackBarBehavior,
        duration: duration,
      ),
    );
  }
}
