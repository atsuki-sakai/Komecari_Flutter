import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleText extends StatelessWidget {
  const TitleText({
    Key key,
    @required this.text,
    this.fontSize = 24.0,
    this.color = Colors.black87,
  }) : super(key: key);
  final String text;
  final double fontSize;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.montserrat(
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
        color: color,
      ),
    );
  }
}
