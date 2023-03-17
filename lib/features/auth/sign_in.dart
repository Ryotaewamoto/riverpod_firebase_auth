import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_firebase_auth/utils/connectivity.dart';

import '../../repositories/auth/auth_repository_impl.dart';
import '../../utils/exceptions/app_exception.dart';
import '../../utils/extensions/firebase_auth_exception.dart';

/// Firebase Auth を用いてサインインをする [AsyncNotifierProvider]。
final signInControllerProvider =
    AutoDisposeAsyncNotifierProvider<SignInController, void>(
  SignInController.new,
);

class SignInController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // FutureOr<void> より、初期の処理の必要がないため何もしない。
    // Do nothing since the return type is void.
  }

  /// サインインする
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    final authRepository = ref.read(authRepositoryImplProvider);
    // サインイン結果をローディング中にする
    state = const AsyncLoading();

    // サインイン処理を実行する
    state = await AsyncValue.guard(() async {
      try {
        final isNetworkCheck = await isNetworkConnected();
        if (!isNetworkCheck) {
          const exception = AppException(
            message: 'Maybe your network is disconnected. Please check yours.',
          );
          throw exception;
        }

        if (email.isEmpty || password.isEmpty) {
          const exception = AppException(
            message: 'Please input your email and password.',
          );
          throw exception;
        }
        await authRepository.signIn(
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
