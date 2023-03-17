import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../repositories/auth/auth_repository_impl.dart';
import '../../utils/connectivity.dart';
import '../../utils/exceptions/app_exception.dart';
import '../../utils/extensions/firebase_auth_exception.dart';

/// Firebase Auth を用いてサインアウトをする [AsyncNotifierProvider]。
final signOutControllerProvider =
    AutoDisposeAsyncNotifierProvider<SignOutController, void>(
  SignOutController.new,
);

class SignOutController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // FutureOr<void> より、初期の処理の必要がないため何もしない。
    // Do nothing since the return type is void.
  }

  /// サインアウトする
  Future<void> signOut() async {
    final authRepository = ref.read(authRepositoryImplProvider);
    // サインアウト結果をローディング中にする
    state = const AsyncLoading();

    // サインアウト処理を実行する
    state = await AsyncValue.guard(() async {
      try {
        final isNetworkCheck = await isNetworkConnected();
        if (!isNetworkCheck) {
          const exception = AppException(
            message: 'Maybe your network is disconnected. Please check yours.',
          );
          throw exception;
        }
        await authRepository.signOut();
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
