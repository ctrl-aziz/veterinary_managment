import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:veterinary_managment/pattern.dart';
import 'package:veterinary_managment/utilities/hive_helper.dart';

import 'view/home_page.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveHelper.openHiveBox("usdBox");
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: AppPattern.darkTheme,
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: HomePage(),
      ),
    );
  }
}