import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../widgets/white_app_bar.dart';
import 'settings_page.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: WhiteAppBar(
        title: 'Home',
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<bool>(
                  builder: (_) => const SettingsPage(),
                ),
              );
            },
            icon: const Icon(
              Icons.settings,
              size: 32,
            ),
          ),
        ],
      ),
      body: Container(),
    );
  }
}
