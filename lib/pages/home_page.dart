import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/auth_provider.dart';
import 'sign_in_page.dart';

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('ホーム'),
      ),
      body: user != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '${user.email}でログイン中',
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                      minimumSize:
                          MaterialStateProperty.all<Size>(const Size(128, 32)),
                    ),
                    onPressed: () async {
                      try {
                        await ref
                            .read(authControllerProvider.notifier)
                            .signOut();
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const SignInPage()),
                          (_) => false,
                        );
                      } catch (e) {
                        print('サインアウトでエラーだよ');
                      }
                    },
                    child: const Text('サインアウト'),
                  ),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
