import 'package:flutter/material.dart';

class NavigatorHelper{

  static push(BuildContext context, var page){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context)=> page,
      ),
    );
  }

}