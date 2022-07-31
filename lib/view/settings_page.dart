import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:veterinary_managment/model/product.dart';
import 'package:veterinary_managment/pattern.dart';
import 'package:veterinary_managment/provider/app_provider.dart';
import 'package:veterinary_managment/provider/product_provider.dart';
import 'package:veterinary_managment/widget/k_input.dart';
import 'package:veterinary_managment/widget/k_text.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}
class _SettingsPageState extends ConsumerState<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    final usd = ref.read(usdProvider.notifier);
    final product = ref.read(productProvider.notifier);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const KText(
            "الإعدادات"
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Row(
              children: [
                SizedBox(width: AppPattern.kPadding,),
                Expanded(
                  flex: 5,
                  child:!usd.editUsdPrice ?
                  Row(
                    children: [
                      const KText("سعر الدولار: " , fontSize: 20.0, textType: TextType.text),
                      KText("${usd.usdPrice}" , fontSize: 20.0, textType: TextType.number,),
                    ],
                  ) :
                  KInput(
                      "سعر الدولار",
                      initialValue: usd.usdPrice.toString(),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.start,
                      onChanged: (val){
                        usd.newUsdPrice = val;
                      },
                    ),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: (){
                      if(usd.editUsdPrice){
                        if(usd.newUsdPrice != null) {
                          product.setLoading();
                          usd.usdPrice = double.parse(usd.newUsdPrice!);
                          product.getProducts();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: KText("تم تحديث سعر الصرف"),
                            ),
                          );
                        }
                      }
                      setState(() {
                        usd.editUsdPrice = !usd.editUsdPrice;
                      });
                    },
                    child: KText(
                      usd.editUsdPrice ?
                      "حفظ" :
                      "تعديل",
                      color: AppPattern.secondaryColor,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            Divider(color: AppPattern.secondaryColor,),
            const Align(
              alignment: Alignment(.8,0),
              child: KText(
                "نسخة إحتياطية: ",
                fontSize: 20.0,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () async{
                    if (await Permission.storage.request().isGranted) {
                      await backupHiveBox<Product>(
                        "products",
                        "/storage/emulated/0/Download/products.hive",
                      ).then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: KText("تم التخزين في مجلد التنزيلات"),
                          ),
                        );
                      });
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: KText("يرجى منح الوصل الى الذاكرة"),
                        ),
                      );
                    }
                  },
                  child: KText(
                    "حفظ",
                    color: AppPattern.mainColor,
                  ),
                ),
                TextButton(
                  onPressed: ()async{
                    if (await Permission.storage.request().isGranted) {
                      product.setLoading();
                      await restoreHiveBox<Product>(
                        "products",
                        "/storage/emulated/0/Download/products.hive",
                      ).then((value) {
                        product.getProducts();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: KText("تم الاستعادة بنجاح"),
                          ),
                        );
                      });
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: KText("يرجى منح الوصل الى الذاكرة"),
                        ),
                      );
                    }

                  },
                  child: KText(
                    "إستعادة",
                    color: AppPattern.mainColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppPattern.kPadding,),
            Divider(color: AppPattern.secondaryColor,),
          ],
        ),
      ),
    );
  }

  Future<void> backupHiveBox<T>(String boxName, String backupPath) async {
    final box = await Hive.openBox<T>(boxName);
    final boxPath = box.path;
    await box.close();

    try {
      File(boxPath!).copy(backupPath);
    } finally {
      await Hive.openBox<T>(boxName);
    }
  }

  Future<void> restoreHiveBox<T>(String boxName, String backupPath) async {
    final box = await Hive.openBox<T>(boxName);
    final boxPath = box.path;
    await box.close();

    try {
      File(backupPath).copy(boxPath!);
    } finally {
      await Hive.openBox<T>(boxName);
    }
  }

}
