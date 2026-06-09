import 'package:flutter/material.dart';

class Customtextfield extends StatelessWidget {
  final String? hintText;
  final Widget? prefixIcon;
  final bool obscureText;
  final Widget? suffixIcon;
  // final int? maxLines;
  final TextEditingController? controller;
  final TextStyle? style;
  final String? Function(String?)? validator;
  final InputDecoration? decoration;
  final TextCapitalization textcapitalize;

  const Customtextfield({
    super.key,
    this.hintText,
    this.prefixIcon,
    this.obscureText = false,
    this.controller,
    this.suffixIcon,
    // this.maxLines,
    this.style,
    this.validator,
    this.decoration,
    required this.textcapitalize,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      textCapitalization: textcapitalize,
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white, fontSize: 18),
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(69, 90, 100, 1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(69, 90, 100, 1)),
        ),
        fillColor: Color.fromRGBO(69, 90, 100, 1),
        hintText: hintText,
        hintStyle: TextStyle(color: const Color(0xFF8CA6A9)),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
