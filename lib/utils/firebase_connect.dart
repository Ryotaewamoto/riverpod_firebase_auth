import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'auth_verification.dart';

class FirebaseConnect extends StatelessWidget {
  FirebaseConnect({Key? key}) : super(key: key);

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                  'Something went wrong!\nYou check whether to connect any network.'),
            );
          }
          if (snapshot.hasData) {
            return const AuthVerification();
          }
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }));
  }
}
