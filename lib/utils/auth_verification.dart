import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../pages/home_page.dart';
import '../pages/sign_in_page.dart';
import '../providers/user_state_provider.dart';

class AuthVerification extends HookConsumerWidget {
  const AuthVerification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(userStateProvider);
    return authState.when(data: (data) {
      // ログイン済みの場合
      if (data != null) {
        return const MyHomePage();
      }
      // 未ログインの場合
      return const SignInPage();
    }, loading: () {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }, error: (_, __) {
      return const Scaffold(
        body: Center(
          child: Text('エラーだよ'),
        ),
      );
    });
  }
}
