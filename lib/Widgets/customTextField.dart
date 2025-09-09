import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mana_driver/Widgets/colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType keyboardType;
  final bool obscureText;
  final Color labelColor;
  final bool readOnly;
  final Color textColor;
  final Color borderColor;
  final double fontSize;
  final int? maxLines;
  final Widget? suffix;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.labelColor = Colors.grey,
    this.textColor = korangeColor,
    this.borderColor = const Color(0xFFD5D7DA),
    this.fontSize = 16,
    this.maxLines,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: TextInputAction.next,
      obscureText: obscureText,
      readOnly: readOnly,
      maxLines: maxLines ?? 1,

      style: GoogleFonts.poppins(color: textColor, fontSize: fontSize),
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon:
            suffix != null
                ? Padding(padding: const EdgeInsets.all(15), child: suffix)
                : null,

        labelStyle: GoogleFonts.poppins(color: labelColor, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: kbordergreyColor, width: 2),
        ),
      ),
    );
  }
}
