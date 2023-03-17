import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'dialog.dart';
import 'exceptions/app_exception.dart';

/// [AsyncValue] の [error] には基本的に [AppException] が入る。そうでない場合、
/// [_message] で [String] に変換する処理を行う。
/// [AppException] でない場合はエラーハンドリングの漏れであるので注意。
extension AsyncValueErrorDialog on AsyncValue<void> {
  void showAlertDialogOnError(BuildContext context) {
    debugPrint('isLoading: $isLoading, hasError: $hasError');
    if (!isLoading && hasError) {
      showExceptionAlertDialog(
        context: context,
        title: 'エラー',
        exception: error,
      );
    }
  }
}

Future<void> showExceptionAlertDialog({
  required BuildContext context,
  required String title,
  required dynamic exception,
}) =>
    showAlertDialog(
      context: context,
      title: title,
      content: _message(exception),
      defaultActionText: 'OK',
    );

String _message(dynamic exception) {
  if (exception is AppException) {
    return exception.message ?? exception.toString();
  }
  if (exception is PlatformException) {
    return exception.message ?? exception.toString();
  }
  return exception.toString();
}
