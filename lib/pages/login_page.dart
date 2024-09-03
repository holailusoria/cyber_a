import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:cyber_a/bloc/change_language/change_language_bloc.dart';
import 'package:cyber_a/bloc/forgot_password/forgot_password_bloc.dart';
import 'package:cyber_a/bloc/login/login_bloc.dart';
import 'package:cyber_a/constants/constants.dart';
import 'package:cyber_a/features/local_storage.dart';
import 'package:cyber_a/utils/language_presentation.dart';
import 'package:cyber_a/widgets/alerts/animated_alert_dialog.dart';
import 'package:cyber_a/widgets/my_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/alerts/forgot_password_alert.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key,});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LoginBloc loginBloc = LoginBloc();
  final ForgotPasswordBloc forgotPasswordBloc = ForgotPasswordBloc();
  bool _stayLoggedIn = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _signup(context),
      ///TODO: add app bar to the application;
      appBar: AppBar(
        title: const Text(
            appName,
        ),
        leading: _dropDownList(context),
        leadingWidth: 100,
      ),
      body: BlocBuilder<LoginBloc, LoginState>(
        bloc: loginBloc,
        builder: (context, state) {
          if(state is LoginInitialState) {
            loginBloc.add(LoginCheckInitialEvent());
          }

          if (state is LoginCompletedState) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              await Navigator.of(context).popAndPushNamed('/home');
            });
          }
          if (state is LoginFailureState) {
            String title = AppLocalizations.of(context)!.loginFailed;
            String? message;

            if (state.exception is BackendlessException) {
              int? exceptionCode = (state.exception as BackendlessException)
                  .code;
              if (exceptionCode != null && exceptionCode == 3003) {
                message =
                    AppLocalizations.of(context)!.invalidLoginOrPasswordMessage;
              }

              if (exceptionCode != null && exceptionCode == 3006) {
                message =
                    AppLocalizations.of(context)!.loginOrPasswordIsMissing;
              }

              if (exceptionCode != null && exceptionCode == 3087) {
                message = AppLocalizations.of(context)!.emailConfirmNeed;
              }
            }

            WidgetsBinding.instance.addPostFrameCallback((_) {
              openDialog(context, title, message ?? state.exception.toString());
            });
          }

          return Center(
            child: Container(
                margin: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 16.0,),
                    _header(context),
                    state is LoginCompletingState
                        ? const CircularProgressIndicator()
                        : const SizedBox(),
                    _inputFields(context),
                    const SizedBox(height: 64.0),
                    _loginButton(context),
                    //_whiteSquares(context),
                  ],
                )
            ),
          );
        },
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Column(
      children: [
        Text(AppLocalizations.of(context)!.loginRequest),
        const SizedBox(height: 16,),
      ],
    );
  }

  Widget _dropDownList(BuildContext context) {
    return DropdownButton(
      underline: const SizedBox(),
      isExpanded: true,
      padding: const EdgeInsets.only(left: 8.0, top: 8.0),
      borderRadius: BorderRadius.zero,
      elevation: 0,
      enableFeedback: true,
      alignment: Alignment.centerLeft,
      items: AppLocalizations.supportedLocales.map((value) =>
          DropdownMenuItem(
            value: value.languageCode,
            child: Container(
              padding: EdgeInsets.zero,
              child: Text(
                languagePresentation[value.languageCode]!,
                style: Theme.of(context).dropdownMenuTheme.textStyle,
                maxLines: 1,
              ),
            ),
          ),
      ).toList(),
      onChanged: (lang) async {
        MyApp.changeLanguageBloc.add(ChangeLanguageTappedEvent(lang!));
        await LocalStorage.saveCurrentLanguage(lang);
      },
      hint: const Align(
        alignment: Alignment.center,
        child: Icon(
          Icons.language,
        ),
      ),
      // Text(
      //   AppLocalizations.of(context)!.language,
      //   style: Theme
      //       .of(context)
      //       .textTheme
      //       .bodyMedium,),
    );
  }

  Widget _inputFields(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            hintStyle: Theme.of(context).textTheme.bodySmall,
            hintText: AppLocalizations.of(context)!.username,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Theme.of(context).inputDecorationTheme.fillColor,
            filled: Theme.of(context).inputDecorationTheme.filled,
            prefixIcon: const Icon(Icons.person),
          ),
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
        ),
        const SizedBox(height: 16,),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
            labelStyle: const TextStyle(
              color: Color.fromRGBO(0, 154, 99, 1.0),
            ),
            hintStyle: Theme.of(context).textTheme.bodySmall,
            hintText: AppLocalizations.of(context)!.password,
            border: Theme.of(context).inputDecorationTheme.border,
            fillColor: Theme.of(context).inputDecorationTheme.fillColor,
            filled: Theme.of(context).inputDecorationTheme.filled,
            prefixIcon: const Icon(Icons.password),
          ),
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
        ),
        const SizedBox(height: 16,),
        _rememberMe(context),
      ],
    );
  }

  Widget _rememberMe(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 4, child: _forgotPassword(context)),
        Expanded(
          flex: 1,
          child: StatefulBuilder(
            builder: (context, setState) {
              return Checkbox(
                  value: _stayLoggedIn,
                  checkColor: Theme.of(context).appBarTheme.backgroundColor,
                  fillColor: Theme.of(context).elevatedButtonTheme.style!.backgroundColor,
                  onChanged: (val) {
                    setState(() {
                      _stayLoggedIn = val!;
                    });
                  });
            }
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            AppLocalizations.of(context)!.rememberMe,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _loginButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            loginBloc.add(LoginTappedEvent(_usernameController.value.text,
                _passwordController.value.text, _stayLoggedIn));
          },
          style: Theme.of(context).elevatedButtonTheme.style,
          child: Text(AppLocalizations.of(context)!.login,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _forgotPassword(context) {
    return TextButton(
      onPressed: () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          openForgotPasswordAlert(context);
        });
      },
      child: Text(
        AppLocalizations.of(context)!.forgotPasswordButton,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }

  Widget _signup(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(AppLocalizations.of(context)!.dontHaveAnAccount),
          TextButton(
            onPressed: () {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
                await Navigator.of(context).pushNamed('/signUp');
              });
            },
            child: Text(
              AppLocalizations.of(context)!.signUpButton,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }

  Widget _whiteSquares(context) {
    return Expanded(
      child: Stack(
        children: [
          Positioned(
              right: 75,
              top: 35,
              child: _whiteSquare(context)
          ),
          _whiteSquare(context),
          Positioned(
            left: 25,
            bottom: 200,
            child: _whiteSquare(context),
          ),
        ],
      ),
    );
  }

  Widget _whiteSquare(context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        width: 96,
        height: 96,
        decoration: const ShapeDecoration(
          color: Color.fromRGBO(255, 255, 255, 0.05),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
        ),
      ),
    );
  }
}
