import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_firebase_auth/repositories/auth_repository.dart';

final authControllerProvider =
    StateNotifierProvider.autoDispose<AuthController, User?>(
  (ref) => AuthController(ref.read),
);

class AuthController extends StateNotifier<User?> {
  final Reader _read;

  AuthController(this._read) : super(null);

  @override
  User? get state => _read(authRepositoryProvider).getCurrentUser();

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _read(authRepositoryProvider).signInWithEmail(email, password);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> signUp(String email, String password) async {
    await _read(authRepositoryProvider).signUp(email, password);
    // Firestoreにユーザデータを追加したり
  }

  Future<void> signOut() async {
    await _read(authRepositoryProvider).signOut();
  }
}
