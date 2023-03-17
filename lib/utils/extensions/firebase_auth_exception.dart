import 'package:firebase_auth/firebase_auth.dart';

extension FirebaseAuthExceptionEx on FirebaseAuthException {
  String get toJapanese {
    switch (code) {
      case 'network-request-failed':
        return '通信がエラーになったのか、またはタイムアウトになりました。通信環境がいい所で再度やり直してください。';
      case 'weak-password':
        return 'パスワードが短すぎます。6文字以上を入力してください。';
      case 'invalid-email':
        return 'メールアドレスの形式が正しくありません';
      case 'user-not-found':
        return 'アカウントが見つかりません';
      case 'wrong-password':
        return 'パスワードが正しくありません';
      case 'email-already-in-use':
        return 'メールアドレスがすでに使用されています。ログインするか別のメールアドレスで作成してください';
      default: // 想定外
        return 'エラー発生しました。通信環境がいい所で再度やり直してください。';
    }
  }

  String get toEnglish {
    switch (code) {
      case 'network-request-failed':
        // ignore: lines_longer_than_80_chars
        return 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.';
      case 'weak-password':
        return 'The password is not strong enough.';
      case 'invalid-email':
        return 'The email used is invalid.';
      case 'user-not-found':
        return 'There is no user corresponding to the given email.';
      case 'wrong-password':
        return 'The password is invalid for the given email.';
      case 'email-already-in-use':
        return 'There already exists an account with the given email address.';
      default: // Unexpected error
        return 'A error has occurred.';
    }
  }
}
