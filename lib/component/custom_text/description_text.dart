import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DescriptionText extends StatelessWidget {
  const DescriptionText({
    Key key,
    @required this.text,
    this.fontSize = 18.0,
    this.color,
  }) : super(key: key);
  final String text;
  final double fontSize;
  final color;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.montserrat(
          fontSize: fontSize,
          fontWeight: FontWeight.w300,
          color: color ?? Colors.grey.shade400),
    );
  }
}
