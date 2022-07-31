import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:veterinary_managment/pattern.dart';

import 'k_text.dart';

class KInput extends StatelessWidget {
  final String title;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final bool needValidate;
  final String? initialValue;
  final TextDirection? textDirection;
  final TextAlign textAlign;
  const KInput(this.title ,{
    Key? key,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.onChanged,
    this.needValidate = true,
    this.initialValue,
    this.textDirection,
    this.textAlign = TextAlign.start,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 15.0),
      child: TextFormField(
        controller: controller,
        initialValue: controller == null ? initialValue : null,
        style: keyboardType == TextInputType.text ?
        GoogleFonts.cairo(color: AppPattern.secondaryColor) :
        GoogleFonts.lemonada(color: AppPattern.secondaryColor),
        keyboardType: keyboardType,
        decoration: InputDecoration(label: KText(title)),
        onChanged: onChanged,
        textDirection: textDirection,
        textAlign: textAlign,
        validator: needValidate ? (val){
          if(val == null || val.isEmpty){
            return "لا يمكن تركه فارغ";
          }else{
            return null;
          }
        } : null,
      ),
    );
  }
}