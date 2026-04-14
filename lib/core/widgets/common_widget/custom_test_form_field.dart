import 'package:final_project/core/constents/app_textStyle.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? suffixIcon;
  final bool hasError;
  final Widget? prefixIcon;
final TextEditingController? controller;

  const CustomTextFormField({
    super.key,
    required this.hintText,
    required this.labelText,
    this.validator,
    this.obscureText = false,
    this.suffixIcon,
    this.hasError = false,
    this.prefixIcon,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: AppTextstyle.body.copyWith(
            color: hasError ? Colors.red : Colors.black,
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextstyle.h2,
            filled: true,
            fillColor: Colors.white,
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: hasError
                  ? const BorderSide(color: Colors.red, width: 1.5)
                  : BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: hasError
                  ? const BorderSide(color: Colors.red, width: 1.5)
                  : const BorderSide(color: Color(0xff4cae4f), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}