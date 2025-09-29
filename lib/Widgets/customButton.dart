import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mana_driver/Widgets/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;

  final double fontSize;
  final FontWeight fontWeight;
  final Color textColor;
  final Color backgroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,

    this.fontSize = 16,
    this.fontWeight = FontWeight.w500,
    this.textColor = Colors.white,
    this.backgroundColor = korangeColor,
    this.borderRadius = 70,

    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 05),
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: padding,
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
