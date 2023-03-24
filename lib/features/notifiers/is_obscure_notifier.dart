import 'package:hooks_riverpod/hooks_riverpod.dart';

class IsObscureNotifier extends AutoDisposeNotifier<bool> {
  @override
  bool build() => true;

  bool toUnobscured() => state = false;

  bool toObscured() => state = true;
}
