import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        body: Row(
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
                  textAlign: TextAlign.end,
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
      ),
    );
  }


}
