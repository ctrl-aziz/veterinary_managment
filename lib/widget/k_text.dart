import 'package:flutter/material.dart';
import 'package:veterinary_managment/pattern.dart';

enum TextType {text, number}
class KText extends StatelessWidget {
  final String text;
  final TextType textType;
  final double? fontSize;
  final Color? color;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;
  const KText(this.text, {
    Key? key,
    this.textType = TextType.text,
    this.color,
    this.fontSize,
    this.textAlign,
    this.fontWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: textType == TextType.number ? TextStyle(
        fontFamily: "Lemonada",
        fontSize: fontSize,
        color: color ?? AppPattern.secondaryColor,
      ) : TextStyle(
        fontFamily: "Cairo",
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color ?? AppPattern.secondaryColor,
      ),
      textAlign: textAlign,
    );
  }
}
