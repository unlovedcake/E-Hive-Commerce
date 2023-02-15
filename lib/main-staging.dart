import 'package:adopt_a_pet/provider-controller/Provider-Controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app-config.dart';
import 'app.dart';

void main() async {
  AppConfig devAppConfig = AppConfig(appName: 'E-Hive Staging', flavor: 'staging');
  Widget app = await initializeApp(devAppConfig);
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => ProviderController()),
    ], child: app),
  );
}

/*
flutter run -t lib/main-dev.dart  --flavor=dev
# Debug signing configuration + dev flavor
flutter run -t lib/main_dev.dart  --debug --flavor=dev
flutter run -t lib/main_dev.dart  --release --flavor=dev
flutter build appbundle -t lib/main_dev.dart  --flavor=dev
flutter build apk -t lib/main-staging.dart  --flavor=staging
*/
