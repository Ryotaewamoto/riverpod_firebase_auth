import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../features/auth/sign_out.dart';
import '../../repositories/auth/auth_repository_impl.dart';
import '../../utils/async_value_error_dialog.dart';
import '../../utils/constants/app_colors.dart';
import '../../utils/dialog.dart';
import '../../utils/exceptions/app_exception.dart';
import '../../utils/loading.dart';
import '../../utils/scaffold_messenger_service.dart';
import '../../utils/text_styles.dart';
import '../../widgets/white_app_bar.dart';
import 'auth_page.dart';

class SettingsPage extends HookConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<void>>(
      signOutControllerProvider,
      (_, state) async {
        if (state.isLoading) {
          ref.read(overlayLoadingProvider.notifier).startLoading();
          return;
        }

        await state.when(
          data: (_) async {
            // ローディングを非表示にする
            ref.read(overlayLoadingProvider.notifier).endLoading();

            // ログインできたらスナックバーでメッセージを表示してホーム画面に遷移する
            ref
                .read(scaffoldMessengerServiceProvider)
                .showSnackBar('Complete to log out!');

            await Navigator.pushAndRemoveUntil<dynamic>(
              context,
              MaterialPageRoute<dynamic>(
                builder: (_) => const AuthPage(),
              ),
              (_) => false,
            );
          },
          error: (e, s) async {
            // ローディングを非表示にする
            ref.read(overlayLoadingProvider.notifier).endLoading();

            // エラーが発生したらエラーダイアログを表示する
            state.showAlertDialogOnError(context);
          },
          loading: () {
            // ローディングを表示する
            ref.read(overlayLoadingProvider.notifier).startLoading();
          },
        );
      },
    );

    // Provider
    final state = ref.watch(signOutControllerProvider);
    final userEmail = ref.watch(authRepositoryImplProvider).currentUser?.email;

    return Stack(
      children: [
        Scaffold(
          appBar: const WhiteAppBar(
            title: 'Settings',
            automaticallyImplyLeading: true,
          ),
          body: Column(
            children: [
              // TODO(ryotaiwamoto): メールアドレスの変更
              // InkWell(
              //   onTap: () {},
              //   highlightColor: AppColors.secondaryPale,
              //   splashColor: AppColors.secondaryPale,
              // child:
              SizedBox(
                height: 64,
                child: ListTile(
                  leading: const Icon(Icons.mail),
                  horizontalTitleGap: 0,
                  title: Text(
                    'Email',
                    style: TextStyles.p1(),
                  ),
                  subtitle: Text(
                    userEmail ?? '',
                    style: TextStyles.p2(),
                  ),
                ),
              ),
              const Divider(
                height: 0,
                color: AppColors.baseLight,
              ),
              InkWell(
                onTap: () async {
                  ref.read(overlayLoadingProvider.notifier).startLoading();
                  try {
                    // App users will check Terms of service
                    // with the web url or text in the app.
                  } on AppException catch (e) {
                    await showAlertDialog(
                      context: context,
                      title: 'Error',
                      content: e.message,
                      defaultActionText: 'OK',
                    );
                  } finally {
                    ref.read(overlayLoadingProvider.notifier).endLoading();
                  }
                },
                highlightColor: AppColors.secondaryPale,
                splashColor: AppColors.secondaryPale,
                child: ListTile(
                  title: Text(
                    'Terms of service',
                    style: TextStyles.p1(),
                  ),
                  trailing: const Icon(Icons.keyboard_arrow_right),
                ),
              ),
              const Divider(
                height: 0,
                color: AppColors.baseLight,
              ),
              InkWell(
                onTap: () async {
                  ref.read(overlayLoadingProvider.notifier).startLoading();
                  try {
                    // App users will check Privacy Policy.
                    // with the web url or text in the app.
                  } on AppException catch (e) {
                    await showAlertDialog(
                      context: context,
                      title: 'Error',
                      content: e.message,
                      defaultActionText: 'OK',
                    );
                  } finally {
                    ref.read(overlayLoadingProvider.notifier).endLoading();
                  }
                },
                highlightColor: AppColors.secondaryPale,
                splashColor: AppColors.secondaryPale,
                child: ListTile(
                  title: Text(
                    'Privacy policy',
                    style: TextStyles.p1(),
                  ),
                  trailing: const Icon(Icons.keyboard_arrow_right),
                ),
              ),
              const Divider(
                height: 0,
                color: AppColors.baseLight,
              ),
              InkWell(
                onTap: () {
                  // Navigate to a page which a app user can delete a account.
                },
                highlightColor: AppColors.secondaryPale,
                splashColor: AppColors.secondaryPale,
                child: ListTile(
                  leading: const Icon(Icons.delete_forever_sharp),
                  horizontalTitleGap: 0,
                  title: Text(
                    'Delete a account',
                    style: TextStyles.p1(),
                  ),
                ),
              ),
              const Divider(
                height: 0,
                color: AppColors.baseLight,
              ),
              Center(
                child: TextButton(
                  onPressed: () async {
                    await showActionDialog(
                      context: context,
                      title: 'Log Out',
                      content: 'Do you want to log out ?',
                      onPressed: state.isLoading
                          ? null
                          : () async {
                              await ref
                                  .read(signOutControllerProvider.notifier)
                                  .signOut();
                            },
                    );
                  },
                  child: Text(
                    'Log out',
                    style: TextStyles.p2(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (ref.watch(overlayLoadingProvider)) const OverlayLoadingWidget(),
      ],
    );
  }
}
