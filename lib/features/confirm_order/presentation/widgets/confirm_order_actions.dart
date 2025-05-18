import 'package:flutter/material.dart';
import '../../../../../core/widgets/action_button.dart';

class ConfirmOrderActions extends StatelessWidget {
  final VoidCallback onSend;

  const ConfirmOrderActions({super.key, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ActionButton(
          label: "Not Yet",
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/cartScreen');
          },
        ),
        ActionButton(
          label: " Send Order",
          onPressed: onSend,
        ),
      ],
    );
  }
}
