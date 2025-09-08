import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mana_driver/Widgets/colors.dart';

class CustomCancelButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double fontSize;
  final FontWeight fontWeight;
  final Color textColor;
  final Color backgroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double? width;
  final double? height;

  const CustomCancelButton({
    Key? key,
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,

        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey.shade300, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(70),
          ),
          backgroundColor: Colors.white,
          padding: padding,    
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF414651),
          ),
        ),
      ),
    );
  }
}
