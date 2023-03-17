# Firebase Authentication with Flutter & Riverpod v2

Firebase Authentication with Flutter & Riverpod v2:

| <img src="https://user-images.githubusercontent.com/75112184/225824797-0ca316b8-c7b3-4677-a35e-9561e0a82881.png" width=200> | <img src="https://user-images.githubusercontent.com/75112184/225824776-71224ce5-9690-4e8f-8b01-268cf8697ccb.png" width=200> | <img src="https://user-images.githubusercontent.com/75112184/225824789-277209e2-d086-43b7-bcb9-5779a1c0b2b7.png" width=200> |

https://user-images.githubusercontent.com/75112184/225837462-b6fa7fa5-a557-422a-9e59-8e57e2278834.mp4


This app architecture is like MVC.

> Note: If you struggle on architecture, I'll recommend [Riverpod Architecture (written by Andrea)](https://codewithandrea.com/articles/flutter-app-architecture-riverpod-introduction/). The article introduce almost used architecture.

## Flutter

This app works by iOS and Android.

```
$ flutter --version
Flutter 3.7.0 • channel stable • https://github.com/flutter/flutter.git
Framework • revision b06b8b2710 (7 weeks ago) • 2023-01-23 16:55:55 -0800
Engine • revision b24591ed32
Tools • Dart 2.19.0 • DevTools 2.20.1
```

## Firebase

I set up by Firebase CLI.

```
$ flutterfire configure \
  --out=lib/firebase_options.dart \
  --platforms=android,ios \
  --ios-bundle-id=com.ryotaiwamoto.riverpodFirebaseAuth \
  --android-package-name=com.ryotaiwamoto.riverpod_firebase_auth
```

## Features

- **Deal with [Riverpod v2](https://docs-v2.riverpod.dev/)** (using NotifierProvider and AsyncNotifierProvider)
- Firebase settings by Firebase CLI
- Sign up, sign in, reset password, and sigh out (on Firebase Authentication)
- Consider above error handling
- Have useful and simple UI

## Next Steps

- Add tests
- Migration [Go Router](https://pub.dev/packages/go_router)
- Add localization (now only English)


## Reference

- https://github.com/KosukeSaigusa/spajam-2022-final
- https://github.com/Ryotaewamoto/bad-log
