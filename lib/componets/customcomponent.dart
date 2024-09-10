import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String hint;
  final TextEditingController mycontroller;
  final String? Function(String?)? validator;

  const CustomTextFormField(
      {super.key,
      required this.hint,
      required this.mycontroller,
      required this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: mycontroller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        hintText: hint,
        hintStyle: TextStyle(fontSize: 17, color: Colors.blueGrey[300]),
        fillColor: Colors.grey[200],
        filled: true,
      ),
    );
  }
}
