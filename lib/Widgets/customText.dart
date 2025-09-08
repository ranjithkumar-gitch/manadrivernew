import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color textcolor;
  final bool underline;
  final Color? underlineColor;
  final TextAlign? textAlign;

  const CustomText({
    super.key,
    required this.text,
    required this.fontSize,
    required this.fontWeight,
    required this.textcolor,
    this.underline = false,
    this.underlineColor,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,

      style: GoogleFonts.poppins(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: textcolor,
        decoration: underline ? TextDecoration.underline : TextDecoration.none,
        decorationColor: underline ? (underlineColor ?? textcolor) : null,
      ),
    );
  }
}
