import '../extensions/string.dart';

/// アプリ内で使用する例外型のインターフェース。
/// Exception interface used in the app.
class AppException implements Exception {
  const AppException({
    this.code,
    this.message,
    this.defaultMessage = 'エラーが発生しました。',
  });

  /// ステータスコードや独自のエラーコードなどのエラー種別を識別するための文字列
  /// String of identifying Status code or original error code.
  final String? code;

  /// 例外の内容を説明するメッセージ
  /// Error details.
  final String? message;

  /// message が空の場合に使用されるメッセージ
  /// Default message.
  final String defaultMessage;

  @override
  String toString() {
    if (code == null) {
      return (message ?? '').ifIsEmpty(defaultMessage);
    }
    return '[$code] ${(message ?? '').ifIsEmpty(defaultMessage)}';
  }
}
