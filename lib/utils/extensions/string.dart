extension StringExtension on String {
  /// 空文字の場合に変わりの文字を返す。
  String ifIsEmpty(String placeholder) => isEmpty ? placeholder : this;
}
