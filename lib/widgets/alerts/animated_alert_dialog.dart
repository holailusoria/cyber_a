import 'package:cyber_a/bloc/sign_up/sign_up_bloc.dart';
import 'package:flutter/material.dart';


void openDialog<B>(BuildContext context, String title, String message, {String? closeButton, B? blocArgument}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return _AnimatedAlertDialog(title, message, closeButton: closeButton, blocArgument: blocArgument,);
    },
  );
}

class _AnimatedAlertDialog<B> extends StatefulWidget {
  final String title;
  final String message;
  String? closeButton;
  B? blocArgument;
  _AnimatedAlertDialog(this.title, this.message, {super.key, this.closeButton, this.blocArgument });

  @override
  _AnimatedAlertDialogState createState() => _AnimatedAlertDialogState();
}

class _AnimatedAlertDialogState<B> extends State<_AnimatedAlertDialog<B>>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    widget.closeButton ??= 'Close';
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
          backgroundColor: Theme.of(context).colorScheme.background,
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.warning,
                  color: Colors.lightGreen.withOpacity(1.0),
                  size: 32.0,
                ),
                Text(widget.title,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                  fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          content: Text(
              widget.message,
              style: Theme.of(context).textTheme.bodyLarge,
          ),
          actions: <Widget>[
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith((states) => Theme.of(context).appBarTheme.titleTextStyle!.color!.withOpacity(0.2)),
                  //foregroundColor: MaterialStateProperty.resolveWith((states) => Theme.of(context).appBarTheme.titleTextStyle!.color),
                ),
                child: Text(
                    widget.closeButton!,
                style: Theme.of(context).textTheme.bodyMedium,),
                onPressed: () {
                  // Reverse the animation
                  // and close the dialog
                  _controller.reverse();

                  if(widget.blocArgument != null) {
                    if(widget.blocArgument is SignUpBloc) {
                      (widget.blocArgument as SignUpBloc).add(SignUpClosedAlertEvent());
                    }
                  }

                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

