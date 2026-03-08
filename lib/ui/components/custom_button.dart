import 'package:flutter/material.dart';


class CustomButton extends StatelessWidget {
  final String title;
  void Function()? onPressed ;
  CustomButton({super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        child: Text(title)
    );
  }
}
