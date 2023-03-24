import 'package:hooks_riverpod/hooks_riverpod.dart';

class IsCheckTermsNotifier extends AutoDisposeNotifier<bool> {
  @override
  bool build() => false;

  bool changeState({required bool value}) => state = value;
}
