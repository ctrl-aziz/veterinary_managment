import 'package:flutter/material.dart';
import 'package:veterinary_managment/widget/k_text.dart';

class DetailsCard extends StatelessWidget {
  final String title;
  final String subTitle;
  const DetailsCard({
    Key? key,
    required this.title,
    required this.subTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        KText(
          title,
          fontSize: 20,
        ),
        const SizedBox(width: 10.0,),
        KText(
          subTitle,
          fontSize: 20,
        ),
      ],
    );
  }
}