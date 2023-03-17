import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../repositories/auth/auth_repository_impl.dart';
import '../../utils/connectivity.dart';
import '../../utils/exceptions/app_exception.dart';
import '../../utils/extensions/firebase_auth_exception.dart';

/// Firebase Auth を用いてパスワードの再設定用のメールを送信する [AsyncNotifierProvider]。
final sendPasswordResetEmailControllerProvider =
    AutoDisposeAsyncNotifierProvider<SendPasswordResetEmailController, void>(
  SendPasswordResetEmailController.new,
);

class SendPasswordResetEmailController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // FutureOr<void> より、初期の処理の必要がないため何もしない。
  }

  /// パスワードの再設定用のメールを送信する
  Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    final authRepository = ref.read(authRepositoryImplProvider);
    // メールの送信をローディング中にする
    state = const AsyncLoading();

    // メールを送信する
    state = await AsyncValue.guard(() async {
      try {
        final isNetworkCheck = await isNetworkConnected();
        if (!isNetworkCheck) {
          const exception = AppException(
            message: 'Maybe your network is disconnected. Please check yours.',
          );
          throw exception;
        }

        if (email.isEmpty) {
          const exception = AppException(
            message: 'Please input your email.',
          );
          throw exception;
        }
        await authRepository.sendPasswordResetEmail(email: email);
      } on FirebaseAuthException catch (e) {
        final exception = AppException(
          code: e.code,
          message: e.toJapanese,
        );
        debugPrint(e.code);
        throw exception;
      }
    });
  }
}
