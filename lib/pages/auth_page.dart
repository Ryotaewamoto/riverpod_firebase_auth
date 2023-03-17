import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../repositories/auth/auth_repository_impl.dart';
import '../utils/extensions/widget_ref.dart';
import '../utils/loading.dart';
import 'error_page.dart';
import 'get_started_page.dart';
import 'home_page.dart';

/// 注意：画面遷移に [MaterialPageRoute] を採用しているので、ローディング時に重ねる
/// [OverlayLoadingWidget] は各画面で実装が必要である。
/// Remark: If you choice [MaterialPageRoute] like this app,
/// [OverlayLoadingWidget] will be necessary for some pages used loading.
/// 
class AuthPage extends HookConsumerWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.handleConnectivity();

    return Scaffold(
      body: ref.watch(authUserProvider).when(
        data: (data) {
          if (data != null) {
            return const HomePage();
          } else {
            return const GetStartedPage();
          }
        },
        error: (error, stackTrace) {
          return const ErrorPage();
        },
        loading: () {
          return const OverlayLoadingWidget();
        },
      ),
    );
  }
}
