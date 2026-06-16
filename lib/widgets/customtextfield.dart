import 'package:flutter/material.dart';

class Customtextfield extends StatelessWidget {
  final String? hintText;
  final Widget? prefixIcon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final TextStyle? style;
  final String? Function(String?)? validator;
  final InputDecoration? decoration;
  final TextCapitalization textcapitalize;
  final AutovalidateMode? autovalidateMode;
  final ValueChanged<String>? onChanged;
  final bool expands;

  const Customtextfield({
    super.key,
    this.hintText,
    this.prefixIcon,
    this.obscureText = false,
    this.controller,
    this.suffixIcon,
    this.style,
    this.validator,
    this.decoration,
    required this.textcapitalize,
    this.autovalidateMode,
    this.onChanged,
    this.expands = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      onChanged: onChanged,
      autovalidateMode: autovalidateMode,
      textCapitalization: textcapitalize,
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white, fontSize: 18),
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: (decoration ?? const InputDecoration()).copyWith(
        filled: true,
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,

          borderSide: BorderSide(color: Color.fromRGBO(69, 90, 100, 1)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,

          borderSide: BorderSide(color: Color.fromRGBO(69, 90, 100, 1)),
        ),
        fillColor: Color.fromRGBO(69, 90, 100, 1),
        hintText: hintText,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide.none,
        ),
        focusedErrorBorder: UnderlineInputBorder(borderSide: BorderSide.none),
        hintStyle: TextStyle(color: const Color(0xFF8CA6A9)),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}
