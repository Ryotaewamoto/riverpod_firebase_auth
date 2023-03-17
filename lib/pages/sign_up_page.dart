import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../features/auth/sign_up.dart';
import '../../utils/async_value_error_dialog.dart';
import '../../utils/constants/app_colors.dart';
import '../../utils/constants/measure.dart';
import '../../utils/dialog.dart';
import '../../utils/exceptions/app_exception.dart';
import '../../utils/loading.dart';
import '../../utils/scaffold_messenger_service.dart';
import '../../utils/text_form_styles.dart';
import '../../utils/text_styles.dart';
import '../../widgets/gradation_background.dart';
import '../../widgets/rounded_button.dart';
import '../../widgets/text_form_header.dart';
import '../../widgets/white_app_bar.dart';
import '../gen/assets.gen.dart';
import 'home_page.dart';

class SignUpPage extends HookConsumerWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<void>>(
      signUpControllerProvider,
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
                .showSnackBar('Create new account!');

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
    );

    // Provider
    final state = ref.watch(signUpControllerProvider);

    // Hooks
    final isObscure = useState(true);
    final isCheckTerms = useState(false);
    final userNameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Stack(
        children: [
          Scaffold(
            appBar: const WhiteAppBar(
              title: 'Create a account',
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
                      _UserNameTextForm(
                        controller: userNameController,
                      ),
                      Measure.g_16,
                      _EmailTextForm(
                        controller: emailController,
                      ),
                      Measure.g_16,
                      _PasswordTextForm(
                        controller: passwordController,
                        isObscure: isObscure,
                      ),
                      Measure.g_32,
                      _TermsAndPrivacyPolicyText(
                        isCheckTerms: isCheckTerms,
                      ),
                      Measure.g_32,
                      Padding(
                        padding: Measure.p_h32,
                        child: PrimaryRoundedButton(
                          text: 'Create a account',
                          onTap: state.isLoading
                              ? null
                              : () async {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  await ref
                                      .read(signUpControllerProvider.notifier)
                                      .signUp(
                                        isCheckTerms: isCheckTerms.value,
                                        userName: userNameController.value.text,
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
}

class _UserNameTextForm extends StatelessWidget {
  const _UserNameTextForm({
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Measure.p_h32,
      child: Column(
        children: [
          const TextFormHeader(title: 'User name'),
          Measure.g_4,
          TextFormField(
            maxLength: 20,
            controller: controller,
            decoration: AppTextFormStyles.onGeneral(
              iconData: Icons.account_circle,
            ),
          ),
        ],
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

class _PasswordTextForm extends StatelessWidget {
  const _PasswordTextForm({
    required this.controller,
    required this.isObscure,
  });

  final TextEditingController controller;
  final ValueNotifier<bool> isObscure;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Measure.p_h32,
      child: Column(
        children: [
          const TextFormHeader(title: 'Password'),
          Measure.g_4,
          TextFormField(
            obscureText: isObscure.value,
            controller: controller,
            decoration: AppTextFormStyles.onPassword(
              isObscure: isObscure,
            ),
          ),
        ],
      ),
    );
  }
}

class _TermsAndPrivacyPolicyText extends HookConsumerWidget {
  const _TermsAndPrivacyPolicyText({
    required this.isCheckTerms,
  });

  final ValueNotifier<bool> isCheckTerms;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: Measure.p_h48,
      child: Row(
        children: [
          Checkbox(
            activeColor: AppColors.secondary,
            checkColor: AppColors.baseWhite,
            value: isCheckTerms.value,
            onChanged: (value) => isCheckTerms.value = value!,
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'You agree',
                    style: TextStyles.p2(),
                  ),
                  TextSpan(
                    text: ' Terms of service ',
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        ref
                            .read(
                              overlayLoadingProvider.notifier,
                            )
                            .startLoading();
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
                          ref
                              .read(
                                overlayLoadingProvider.notifier,
                              )
                              .endLoading();
                        }
                      },
                    style: TextStyles.p2(
                      color: AppColors.secondary,
                    ),
                  ),
                  TextSpan(
                    text: 'and',
                    style: TextStyles.p2(),
                  ),
                  TextSpan(
                    text: ' Privacy Policy ',
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        ref
                            .read(
                              overlayLoadingProvider.notifier,
                            )
                            .startLoading();
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
                          ref
                              .read(
                                overlayLoadingProvider.notifier,
                              )
                              .endLoading();
                        }
                      },
                    style: TextStyles.p2(
                      color: AppColors.secondary,
                    ),
                  ),
                  TextSpan(
                    text: '.',
                    style: TextStyles.p2(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
