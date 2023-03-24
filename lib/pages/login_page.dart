import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../features/auth/send_password_reset_email.dart';
import '../../features/auth/sign_in.dart';
import '../../utils/async_value_error_dialog.dart';
import '../../utils/constants/app_colors.dart';
import '../../utils/constants/measure.dart';
import '../../utils/loading.dart';
import '../../utils/scaffold_messenger_service.dart';
import '../../utils/text_form_styles.dart';
import '../../utils/text_styles.dart';
import '../../widgets/gradation_background.dart';
import '../../widgets/rounded_button.dart';
import '../../widgets/text_form_header.dart';
import '../../widgets/white_app_bar.dart';
import '../features/notifiers/is_obscure_notifier.dart';
import '../gen/assets.gen.dart';
import 'home_page.dart';

/// Provider

final _emailTextEditingController = Provider<TextEditingController>(
  (_) => TextEditingController(),
);

final _passwordTextEditingController = Provider<TextEditingController>(
  (_) => TextEditingController(),
);
final _sendEmailTextEditingController = Provider<TextEditingController>(
  (_) => TextEditingController(),
);

/// NotifierProvider

final _isObscureProvider = NotifierProvider<IsObscureNotifier, bool>(
  IsObscureNotifier.new,
);

class LogInPage extends HookConsumerWidget {
  const LogInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref
      ..listen<AsyncValue<void>>(
        signInControllerProvider,
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
                  .showSnackBar('Logged in');

              await Navigator.of(context).push<void>(
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
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
      )
      ..listen<AsyncValue<void>>(
        sendPasswordResetEmailControllerProvider,
        (_, state) async {
          if (state.isLoading) {
            ref.read(overlayLoadingProvider.notifier).startLoading();
            return;
          }

          await state.when(
            data: (_) async {
              // ローディングを非表示にする
              ref.read(overlayLoadingProvider.notifier).endLoading();

              Navigator.of(context).pop();

              // ログインできたらスナックバーでメッセージを表示してホーム画面に遷移する
              ref
                  .read(scaffoldMessengerServiceProvider)
                  .showSnackBar('Success of sending email !');
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
    final signInstate = ref.watch(signInControllerProvider);
    final sendEmailState = ref.watch(sendPasswordResetEmailControllerProvider);
    final isObscureState = ref.watch(_isObscureProvider);
    final isObscureNotifier = ref.watch(_isObscureProvider.notifier);
    final emailController = ref.watch(_emailTextEditingController);
    final passwordController = ref.watch(_passwordTextEditingController);
    final sendEmailController = ref.watch(_sendEmailTextEditingController);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Stack(
        children: [
          Scaffold(
            appBar: const WhiteAppBar(
              title: 'Log in',
              elevation: 0,
              automaticallyImplyLeading: true,
            ),
            body: Stack(
              children: [
                const GradationBackground(),
                SingleChildScrollView(
                  reverse: true,
                  child: Column(
                    children: [
                      Measure.g_24,
                      Assets.images.flutterIcon.image(
                        width: 200,
                        height: 200,
                      ),
                      Measure.g_24,
                      _EmailTextForm(
                        controller: emailController,
                      ),
                      Measure.g_16,
                      _PasswordTextForm(
                        controller: passwordController,
                        isObscureState: isObscureState,
                        notifier: isObscureNotifier,
                      ),
                      Measure.g_32,
                      _ForgetPasswordTextButton(
                        onTap: () async {
                          await _sendPasswordResetEmailSheet(
                            context,
                            sendEmailController,
                            sendEmailState,
                            ref,
                          );
                        },
                      ),
                      Measure.g_32,
                      Padding(
                        padding: Measure.p_h32,
                        child: PrimaryRoundedButton(
                          text: 'Log in',
                          onTap: signInstate.isLoading
                              ? null
                              : () async {
                                  await ref
                                      .read(signInControllerProvider.notifier)
                                      .signIn(
                                        email: emailController.value.text,
                                        password: passwordController.value.text,
                                      );
                                },
                        ),
                      ),
                      Measure.g_32,
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (ref.watch(overlayLoadingProvider)) const OverlayLoadingWidget(),
        ],
      ),
    );
  }

  Future<void> _sendPasswordResetEmailSheet(
    BuildContext context,
    TextEditingController useSendEmailController,
    AsyncValue<void> sendEmailState,
    WidgetRef ref,
  ) async {
    await showModalBottomSheet<bool>(
      backgroundColor: AppColors.secondary,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Column(
            children: [
              Measure.g_80,
              const _ResetPasswordBackButton(),
              Measure.g_60,
              const Icon(
                Icons.lock,
                size: 80,
                color: AppColors.baseWhite,
              ),
              Measure.g_60,
              Text(
                'Reset a password',
                style: TextStyles.h3(
                  color: AppColors.baseWhite,
                ),
              ),
              Measure.g_60,
              _ResetEmailTextForm(
                controller: useSendEmailController,
              ),
              Measure.g_60,
              Padding(
                padding: Measure.p_h32,
                child: SecondaryRoundedButton(
                  text: 'Submit',
                  onTap: sendEmailState.isLoading
                      ? null
                      : () async {
                          await ref
                              .read(
                                sendPasswordResetEmailControllerProvider
                                    .notifier,
                              )
                              .sendPasswordResetEmail(
                                email: useSendEmailController.value.text,
                              );
                        },
                ),
              ),
            ],
          ),
        );
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Measure.r_16,
          topRight: Measure.r_16,
        ),
      ),
    );
  }
}

class _EmailTextForm extends StatelessWidget {
  const _EmailTextForm({
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Measure.p_h32,
      child: Column(
        children: [
          const TextFormHeader(title: 'Email'),
          Measure.g_4,
          TextFormField(
            controller: controller,
            decoration: AppTextFormStyles.onGeneral(
              iconData: Icons.mail,
            ),
          ),
        ],
      ),
    );
  }
}

class _ForgetPasswordTextButton extends StatelessWidget {
  const _ForgetPasswordTextButton({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        'Do you forget the password?',
        style: TextStyles.p1(color: AppColors.secondary),
      ),
    );
  }
}

class _PasswordTextForm extends StatelessWidget {
  const _PasswordTextForm({
    required this.controller,
    required this.isObscureState,
    required this.notifier,
  });

  final TextEditingController controller;
  final bool isObscureState;
  final IsObscureNotifier notifier;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Measure.p_h32,
      child: Column(
        children: [
          const TextFormHeader(title: 'Password'),
          Measure.g_4,
          TextFormField(
            obscureText: isObscureState,
            controller: controller,
            decoration: AppTextFormStyles.onPassword(
              state: isObscureState,
              notifier: notifier,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResetEmailTextForm extends StatelessWidget {
  const _ResetEmailTextForm({
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Measure.p_h32,
      child: Column(
        children: [
          const TextFormHeader(
            title: 'Email',
            color: AppColors.baseWhite,
          ),
          Measure.g_16,
          TextFormField(
            style: TextStyles.p1(
              color: AppColors.baseWhite,
            ),
            controller: controller,
            decoration: AppTextFormStyles.onGeneral(
              iconData: Icons.mail,
              color: AppColors.baseWhite,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResetPasswordBackButton extends StatelessWidget {
  const _ResetPasswordBackButton();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: const Icon(
          Icons.close,
          size: 32,
          color: AppColors.baseDark,
        ),
      ),
    );
  }
}
