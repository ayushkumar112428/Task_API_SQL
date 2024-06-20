import 'package:flutter/material.dart';

class UserInput extends StatelessWidget {
  final TextEditingController controller;
  const UserInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    double wSize = MediaQuery.of(context).size.width;
    return SizedBox(
      width: wSize * 0.4,
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: "Enter a number",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(width: 2),
          ),
        ),
      ),
    );
  }
}
