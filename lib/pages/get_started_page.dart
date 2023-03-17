import 'package:flutter/material.dart';

import '../../utils/constants/app_colors.dart';
import '../../utils/constants/measure.dart';
import '../../utils/text_styles.dart';
import '../../widgets/gradation_background.dart';
import '../../widgets/rounded_button.dart';
import '../../widgets/white_app_bar.dart';
import '../gen/assets.gen.dart';
import 'login_page.dart';
import 'sign_up_page.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: const WhiteAppBar(
          title: '',
          elevation: 0,
        ),
        body: Stack(
          children: [
            const GradationBackground(
              startPoint: 0.75,
            ),
            // キーボードを開いた状態でこの画面に pop すると画面幅の問題でエラーが出るため、
            // [SingleChildScrollView] を追加している。
            SingleChildScrollView(
              reverse: true,
              child: Column(
                children: [
                  Measure.g_32,
                  Measure.g_32,
                  Assets.images.flutterIcon.image(
                    width: 200,
                    height: 200,
                  ),
                  Measure.g_32,
                  const _AppTitleText(),
                  Measure.g_32,
                  Padding(
                    padding: Measure.p_h32,
                    child: PrimaryRoundedButton(
                      text: 'Create a account',
                      onTap: () {
                        Navigator.push<dynamic>(
                          context,
                          _fadeAnimationBuilder(widget: const SignUpPage()),
                        );
                      },
                    ),
                  ),
                  Measure.g_16,
                  Padding(
                    padding: Measure.p_h32,
                    child: SecondaryRoundedButton(
                      text: 'Log in',
                      onTap: () async {
                        await Navigator.push<dynamic>(
                          context,
                          _fadeAnimationBuilder(widget: const LogInPage()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

PageRouteBuilder<dynamic> _fadeAnimationBuilder({required Widget widget}) {
  return PageRouteBuilder<dynamic>(
    transitionDuration: const Duration(milliseconds: 400),
    reverseTransitionDuration: const Duration(milliseconds: 500),
    pageBuilder: (context, animation, secondaryAnimation) {
      // 表示する画面のWidget
      return widget;
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // 遷移時のアニメーションを指定
      const begin = 0.0;
      const end = 1.0;
      final tween = Tween(begin: begin, end: end)
          .chain(CurveTween(curve: Curves.easeInOut));
      final doubleAnimation = animation.drive<double>(tween);
      return FadeTransition(
        opacity: doubleAnimation,
        child: child,
      );
    },
  );
}

class _AppTitleText extends StatelessWidget {
  const _AppTitleText();

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: 'Welcome to ',
            style: TextStyles.h2(),
          ),
          TextSpan(
            text: 'My App',
            style: TextStyles.h2(color: AppColors.primary),
          ),
          TextSpan(
            text: ' !!',
            style: TextStyles.h2(),
          ),
        ],
      ),
    );
  }
}
