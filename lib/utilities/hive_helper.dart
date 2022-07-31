import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveHelper{
  static Future<Box> openHiveBox(String boxName) async {
    if (!kIsWeb && !Hive.isBoxOpen(boxName)) Hive.init((await getApplicationDocumentsDirectory()).path);
    return await Hive.openBox(boxName);
  }
}