import 'package:flutter/material.dart';

class CustomButtonAuth extends StatelessWidget {
  final titel;
  final Function()? onPressed;
  const CustomButtonAuth(
      {super.key, required this.titel, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 45,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.orange[400],
      onPressed: onPressed,
      child: Text(
        titel,
        style: const TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }
}

class CustomButtonUpLoading extends StatelessWidget {
  final titel;
  final bool isSelected;
  final Function()? onPressed;
  const CustomButtonUpLoading(
      {super.key,
      required this.titel,
      required this.onPressed,
      required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 45,
      minWidth: 150,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: isSelected == true ? Colors.blueAccent : Colors.orange[400],
      onPressed: onPressed,
      child: Text(
        titel,
        style: const TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }
}
