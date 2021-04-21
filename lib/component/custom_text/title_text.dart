import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleText extends StatelessWidget {
  const TitleText({
    Key key,
    @required this.text,
    this.fontSize = 24.0,
    this.color = Colors.black87,
    this.textOverflow = TextOverflow.ellipsis,
    this.maxLine,
  }) : super(key: key);
  final String text;
  final double fontSize;
  final Color color;
  final TextOverflow textOverflow;
  final int maxLine;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLine,
      overflow: textOverflow,
      style: GoogleFonts.montserrat(
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
        color: color,
      ),
    );
  }
}
