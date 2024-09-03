import 'package:cyber_a/constants/constants.dart';
import 'package:cyber_a/features/local_storage.dart';
import 'package:cyber_a/widgets/my_app.dart';
import '../pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:backendless_sdk/backendless_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Backendless.initApp(
    applicationId: 'E428570E-9807-EB91-FFF3-15EFEBAA1700',
    androidApiKey: 'CC91673B-7C16-42EA-94A5-012040C12EBB',
    iosApiKey: '76147551-B01C-4A7D-8B7B-CA270889DCEF',
  );

  String? currentLanguage = await LocalStorage.getCurrentLanguage();

  runApp(MyApp(currentLanguage));
}
