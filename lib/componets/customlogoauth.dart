import 'package:flutter/material.dart';

class CustomLogoAuth extends StatelessWidget {
  const CustomLogoAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(15),
        height: 80,
        width: 80,
        decoration: BoxDecoration(
            color: Colors.grey[350],
            borderRadius: BorderRadiusDirectional.circular(70)),
        child: Image.asset(
          "images/logo.png",
          height: 60,
        ),
      ),
    );
  }
}
