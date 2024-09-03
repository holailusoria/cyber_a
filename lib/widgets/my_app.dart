import 'package:cyber_a/bloc/change_language/change_language_bloc.dart';
import 'package:cyber_a/features/get_current_locale.dart';
import 'package:cyber_a/pages/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../constants/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../pages/home_page.dart';
import '../pages/login_page.dart';

class MyApp extends StatelessWidget {
  final String? currentLanguage;
  late Locale _locale;
  static final ChangeLanguageBloc changeLanguageBloc = ChangeLanguageBloc();

  MyApp(this.currentLanguage, {super.key});

  @override
  Widget build(BuildContext context) {
    if (currentLanguage != null) {
      _locale = Locale(currentLanguage!);
    } else {
      _locale = getCurrentLocale();
    }

    return BlocBuilder<ChangeLanguageBloc, ChangeLanguageState>(
      bloc: changeLanguageBloc,
      builder: (context, state) {
        if (state is ChangeLanguageAppearedState) {
          _locale = state.language;
        }
        return MaterialApp(
          routes: {
            '/': (context) => const LoginPage(),
            '/home': (context) => const HomePage(title: appName,),
            '/signUp' : (context) => const SignUpPage(),
          },
          debugShowCheckedModeBanner: false,
          title: appName,
          locale: _locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            dropdownMenuTheme: DropdownMenuThemeData(
              menuStyle: MenuStyle(
                minimumSize: WidgetStateProperty.resolveWith((states) => const Size(200, 100)),
              ),
              inputDecorationTheme: const InputDecorationTheme(

              ),
              textStyle: const TextStyle(
                fontSize: 16.0,
                color: Color.fromRGBO(0, 154, 99, 1.0),
              ),
            ),
            colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromRGBO(1, 1, 33, 0.8),
                surface: const Color.fromRGBO(14, 60, 135, 1.0),
            ),
            useMaterial3: true,
            inputDecorationTheme: InputDecorationTheme(
              prefixIconColor: const Color.fromRGBO(14, 60, 135, 1.0),
              hintStyle: Theme.of(context).textTheme.bodySmall,
              fillColor: Colors.blue.withOpacity(0.2),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
            ),
            scaffoldBackgroundColor: const Color.fromRGBO(1, 1, 33, 0.8),
            appBarTheme: AppBarTheme(
              color: const Color.fromRGBO(14, 60, 135, 1.0),
              iconTheme: const IconThemeData(
                color: Color.fromRGBO(0, 154, 99, 1.0),
              ),
              titleTextStyle: TextStyle(
                color: Colors.white.withOpacity(0.7),//Color.fromRGBO(0, 154, 99, 1.0),
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                //fontStyle: FontStyle.italic,
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                backgroundColor: WidgetStateColor.resolveWith(
                      (states) => const Color.fromRGBO(0, 154, 99, 1.0),
                ),
                minimumSize: WidgetStateProperty.resolveWith(
                      (states) =>
                  const Size(148, 48,
                  ),
                ),
                shape: WidgetStateProperty.resolveWith(
                        (states) =>
                    const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        side: BorderSide(
                          color: Colors.blueGrey,
                          width: 2.5,
                        ),
                    )
                ),
              ),
            ),
            textTheme: TextTheme(
                bodyMedium: const TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                ),
                bodyLarge: const TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              bodySmall: TextStyle(
                fontSize: 16.0,
                color: Colors.white.withOpacity(0.5),
              )
            ),
            listTileTheme: ListTileThemeData(
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  color: Colors.blue,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 8.0),
              tileColor: Colors.blue.withOpacity(0.2),
              textColor: const Color.fromRGBO(0, 154, 99, 1.0),
            ),
            canvasColor: const Color.fromRGBO(14, 60, 135, 1.0),
          ),
        );
      },
    );
  }
}