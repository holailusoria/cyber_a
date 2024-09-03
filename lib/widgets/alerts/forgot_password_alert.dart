import 'package:cyber_a/bloc/forgot_password/forgot_password_bloc.dart';
import 'package:cyber_a/utils/validators/user_credentials_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'animated_alert_dialog.dart';

void openForgotPasswordAlert(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const _AnimatedForgotPasswordAlertDialog();
    },
  );
}

class _AnimatedForgotPasswordAlertDialog extends StatefulWidget {
  const _AnimatedForgotPasswordAlertDialog();

  @override
  _AnimatedForgotPasswordAlertDialogState createState() => _AnimatedForgotPasswordAlertDialogState();
}

class _AnimatedForgotPasswordAlertDialogState extends State<_AnimatedForgotPasswordAlertDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  final TextEditingController _inputController = TextEditingController();
  final ForgotPasswordBloc forgotPasswordBloc = ForgotPasswordBloc();

  @override
  void initState(){
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    // Start the animation when
    // the dialog is displayed
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AlertDialog(
          titlePadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.zero,
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Container(
            alignment: Alignment.center,
            height: 48.0,
            decoration: ShapeDecoration(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15),
                ),
              ),
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: Text(AppLocalizations.of(context)!.restorePasswordAlertTitle,
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),
          content: TextFormField(
            controller: _inputController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (input) => input!.isValidUsername() ? '✔' : AppLocalizations.of(context)!.wrongUsernameFormatAlert,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.username,
              errorMaxLines: 3,
            ),
          ),
          actions: <Widget>[
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                child: Text(
                  AppLocalizations.of(context)!.restorePasswordButton,
                  style: Theme.of(context).textTheme.bodyMedium,),
                onPressed: () {
                  // Reverse the animation
                  // and close the dialog

                  if(_inputController.value.text.isValidUsername()) {
                    forgotPasswordBloc.add(ForgotPasswordRestoring(_inputController.value.text));

                    _controller.reverse();

                    Navigator.of(context).pop();

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      openDialog(context, AppLocalizations.of(context)!.checkYourEmailTitle, AppLocalizations.of(context)!.emailWithInstructions, closeButton: AppLocalizations.of(context)!.gotItButton);
                    });
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

