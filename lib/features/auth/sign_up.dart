import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../repositories/auth/auth_repository_impl.dart';
import '../../utils/connectivity.dart';
import '../../utils/exceptions/app_exception.dart';
import '../../utils/extensions/firebase_auth_exception.dart';

/// Firebase Auth を用いてサインアップをする [AsyncNotifierProvider]。
final signUpControllerProvider =
    AutoDisposeAsyncNotifierProvider<SignUpController, void>(
  SignUpController.new,
);

class SignUpController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // FutureOr<void> より、初期の処理の必要がないため何もしない。
    // Do nothing since the return type is void.
  }

  /// 新規登録する
  Future<void> signUp({
    required bool isCheckTerms,
    required String userName,
    required String email,
    required String password,
  }) async {
    final authRepository = ref.read(authRepositoryImplProvider);
    // ログイン結果をローディング中にする
    state = const AsyncLoading();

    // ログイン処理を実行する
    state = await AsyncValue.guard(() async {
      try {
        final isNetworkCheck = await isNetworkConnected();
        if (!isNetworkCheck) {
          const exception = AppException(
            message: 'Maybe your network is disconnected. Please check yours.',
          );
          throw exception;
        }

        if (isCheckTerms == false) {
          const exception = AppException(
            message: 'Please agree the terms of service and privacy policy.',
          );
          throw exception;
        }

        if (userName.isEmpty || email.isEmpty || password.isEmpty) {
          const exception = AppException(
            message: 'Please input your user name, email, and password.',
          );
          throw exception;
        }

        await authRepository.signUp(
          email: email,
          password: password,
        );

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
