import 'package:cyber_a/constants/constants.dart';
import 'package:cyber_a/widgets/alerts/animated_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../utils/validators/user_credentials_validator.dart';
import '../bloc/sign_up/sign_up_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController(text: '');
  final _usernameController = TextEditingController(text: '');
  final _passwordController = TextEditingController(text: '');
  final _repeatPasswordController = TextEditingController(text: '');
  final SignUpBloc signUpBloc = SignUpBloc();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          appName,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
              Icons.arrow_back),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
        child: ElevatedButton(
          onPressed: () {
            String emailValue = _emailController.value.text;
            String usernameValue = _usernameController.value.text;
            String passwordValue = _passwordController.value.text;
            String repeatPasswordValue = _repeatPasswordController.value.text;

            if(!emailValue.isValidEmail() || !usernameValue.isValidUsername() || !passwordValue.isValidPassword() || passwordValue != repeatPasswordValue) {
              return;
            }

            signUpBloc.add(SignUpTappedEvent(emailValue, usernameValue, passwordValue));
          },
          style: theme.elevatedButtonTheme.style,
          child: Text(
            localization.signUpButton,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 10.0),
          alignment: Alignment.center,
          child: BlocBuilder<SignUpBloc, SignUpState>(
            bloc: signUpBloc,
            builder: (context, state) {
              if(state is SignUpCompletedState) {
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  if(context.mounted) {
                    openDialog<SignUpBloc>(context, AppLocalizations.of(context)!
                        .canLoginToAccountAfterEmailConfirmTitle,
                        AppLocalizations.of(context)!
                            .canLoginToAccountAfterEmailConfirmMessage, closeButton: AppLocalizations.of(context)!.gotItButton, blocArgument: signUpBloc);
                  }
                });
              }

              if(state is SignUpClosedAlertState) {
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  await Navigator.of(context).pushNamed('/');
                });
              }

              if(state is SignUpTappedState) {
                return const CircularProgressIndicator();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: _textFields(context),
              );
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _textFields(BuildContext context) {
    return [
      TextFormField(
        controller: _emailController,
        decoration: InputDecoration(
          errorMaxLines: 2,
          prefixIcon: const Icon(Icons.email,),
          prefixIconColor: Theme.of(context).inputDecorationTheme.prefixIconColor,
          hintText: AppLocalizations.of(context)!.email,
          hintStyle: Theme.of(context).textTheme.bodySmall,
          fillColor: Theme.of(context).inputDecorationTheme.fillColor,
          filled: Theme.of(context).inputDecorationTheme.filled,
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (input) => input!.isValidEmail() ? '✔' : AppLocalizations.of(context)!.wrongEmailFormat,
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
      ),
      _divider(),
      TextFormField(
        controller: _usernameController,
        decoration: InputDecoration(
          errorMaxLines: 3,
          prefixIcon: const Icon(Icons.person,),
          prefixIconColor: Theme.of(context).inputDecorationTheme.prefixIconColor,
          hintText: AppLocalizations.of(context)!.username,
          hintStyle: Theme.of(context).textTheme.bodySmall,
          fillColor: Theme.of(context).inputDecorationTheme.fillColor,
          filled: Theme.of(context).inputDecorationTheme.filled,
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (input) => input!.isValidUsername() ? '✔' : AppLocalizations.of(context)!.wrongUsernameFormat,
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
      ),
      _divider(),
      TextFormField(
        controller: _passwordController,
        obscureText: true,
        decoration: InputDecoration(
          errorMaxLines: 2,
          prefixIcon: const Icon(Icons.password,),
          prefixIconColor: Theme.of(context).inputDecorationTheme.prefixIconColor,
          hintText: AppLocalizations.of(context)!.password,
          hintStyle: Theme.of(context).textTheme.bodySmall,
          fillColor: Theme.of(context).inputDecorationTheme.fillColor,
          filled: Theme.of(context).inputDecorationTheme.filled,
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (input) => input!.isValidPassword() ? '✔' : AppLocalizations.of(context)!.wrongPasswordFormat,
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
      ),
      _divider(),
      TextFormField(
        controller: _repeatPasswordController,
        obscureText: true,
        decoration: InputDecoration(
          errorMaxLines: 2,
          prefixIcon: const Icon(Icons.password,),
          prefixIconColor: Theme.of(context).inputDecorationTheme.prefixIconColor,
          hintText: AppLocalizations.of(context)!.repeatPassword,
          hintStyle: Theme.of(context).textTheme.bodySmall,
          fillColor: Theme.of(context).inputDecorationTheme.fillColor,
          filled: Theme.of(context).inputDecorationTheme.filled,
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (input) => input! == _passwordController.value.text ? '✔' : AppLocalizations.of(context)!.wrongRepeatPassword,
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
      ),
    ];
  }

  Widget _divider() {
    return Divider(
      color: Theme.of(context).scaffoldBackgroundColor,
      height: 8.0,
    );
  }
}
