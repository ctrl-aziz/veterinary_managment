import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:veterinary_managment/pattern.dart';

enum TextType {text, number}
class KText extends StatelessWidget {
  final String text;
  final TextType textType;
  final double? fontSize;
  final Color? color;
  final TextAlign? textAlign;
  const KText(this.text, {
    Key? key,
    this.textType = TextType.text,
    this.color,
    this.fontSize,
    this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: textType == TextType.number ? GoogleFonts.lemonada(
        fontSize: fontSize,
        color: color ?? AppPattern.secondaryColor,
      ) : GoogleFonts.cairo(
        fontSize: fontSize,
        color: color ?? AppPattern.secondaryColor,
      ),
      textAlign: textAlign,
    );
  }
}