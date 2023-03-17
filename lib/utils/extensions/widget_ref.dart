import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../connectivity.dart';
import '../loading.dart';
import '../scaffold_messenger_service.dart';

extension WidgetRefEx on WidgetRef {
  /// インターネットの接続状況を監視し、接続が切れた場合にスナックバーを表示する。
  void handleConnectivity() =>
      listen<AsyncValue<ConnectivityResult>>(connectivityProvider, (_, next) {
        if (next.isLoading) {
          // ローディングを表示する
          read(overlayLoadingProvider.notifier).startLoading();
          return;
        }

        next.when(
          data: (data) async {
            // ローディングを非表示にする
            watch(overlayLoadingProvider.notifier).endLoading();
            // インターネット接続が切れた際に
            if (data == ConnectivityResult.none) {
              watch(scaffoldMessengerServiceProvider)
                  .showSnackBar('Please connect to the internet.');
            }
          },
          error: (e, s) async {
            // ローディングを非表示にする
            read(overlayLoadingProvider.notifier).endLoading();
            // エラーが発生したらエラーダイアログを表示する
            watch(scaffoldMessengerServiceProvider)
                .showSnackBar('Please connect to the internet.');
          },
          loading: () {
            // ローディングを表示する
            read(overlayLoadingProvider.notifier).startLoading();
          },
        );
      });
}
