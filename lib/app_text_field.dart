import 'package:flutter/material.dart';
import 'package:teyake/colors.dart';

import 'package:teyake/dimensions.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;
  final IconData icon;
  final String? Function(String?)? validator;
  final bool obscureText;

  const AppTextField(
    GlobalKey<FormState> formKey, {
    Key? key,
    required this.textController,
    required this.hintText,
    required this.icon,
    this.validator,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Dimensions.height20,
        vertical: Dimensions.height10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Dimensions.radius30),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            spreadRadius: 7,
            offset: const Offset(1, 10),
            color: const Color.fromARGB(255, 12, 12, 12).withOpacity(0.2),
          ),
        ],
      ),
      child: TextFormField(
        controller: textController,
        obscureText: obscureText,
        style: const TextStyle(fontSize: 16.0, color: Colors.black),
        decoration: InputDecoration(
          labelText: hintText,
          hintText: 'Enter your $hintText.',
          prefixIcon: Icon(icon, color: AppColors.mainColor),
          border: InputBorder.none, // Remove border to customize it
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        ),
        validator: validator,
      ),
    );
  }
}
