import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// インターネットの接続状況を監視する Provider
/// Listen to the network varying.
final connectivityProvider = StreamProvider((ref) {
  return Connectivity().onConnectivityChanged;
});

/// インターネットに接続しているかどうか
/// Whether to connect to any network.
Future<bool> isNetworkConnected() async {
  final result = await Connectivity().checkConnectivity();
  return result != ConnectivityResult.none;
}
