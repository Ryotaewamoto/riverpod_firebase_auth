import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/auth_provider.dart';
import 'home_page.dart';
import 'sign_up_page.dart';

class SignInPage extends HookConsumerWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController(text: '');
    final passwordController = useTextEditingController(text: '');

    return Scaffold(
      appBar: AppBar(title: const Text('ログイン')),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 24,
          horizontal: 32,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.mail),
                label: Text('メールアドレス'),
                hintText: 'test@gmail.com',
              ),
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            TextFormField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.lock),
                label: Text('パスワード'),
                hintText: 'password',
              ),
              controller: passwordController,
              obscureText: true,
            ),
            const SizedBox(
              height: 48,
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                minimumSize:
                    MaterialStateProperty.all<Size>(const Size(128, 32)),
              ),
              onPressed: () async {
                try {
                  if (emailController.text.isEmpty) {
                    throw 'メールアドレスを入力してください';
                  }
                  if (passwordController.text.isEmpty) {
                    throw 'パスワードを入力してください';
                  }
                  await ref.read(authControllerProvider.notifier).signIn(
                        emailController.text,
                        passwordController.text,
                      );
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const MyHomePage()),
                    (_) => false,
                  );
                } catch (e) {
                  print('サインインでエラーだよ');
                }
              },
              child: const Text('ログイン'),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.teal),
                minimumSize:
                    MaterialStateProperty.all<Size>(const Size(128, 32)),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SignUpPage(),
                    fullscreenDialog: true,
                  ),
                );
              },
              child: const Text('新規登録'),
            ),
          ],
        ),
      ),
    );
  }
}
