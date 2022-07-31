import 'package:flutter/material.dart';
import 'package:veterinary_managment/widget/k_text.dart';
import 'package:veterinary_managment/pattern.dart';

class MainCard extends StatelessWidget {
  final String title;
  final String number;
  const MainCard({
    Key? key,
    required this.title,
    required this.number,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Card(
      child: SizedBox(
        width: (size.width / 2) - 10,
        child: Column(
          children: [
            KText(
              title,
              color: AppPattern.mainColor,
            ),
            KText(
              number,
              textType: TextType.number,
              color: AppPattern.mainColor,
            ),
          ],
        ),
      ),
    );
  }
}