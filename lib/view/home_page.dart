import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:veterinary_managment/pattern.dart';
import 'package:veterinary_managment/provider/app_provider.dart';
import 'package:veterinary_managment/provider/product_provider.dart';
import 'package:veterinary_managment/utilities/math_helper.dart';
import 'package:veterinary_managment/utilities/navigator_helper.dart';
import 'package:veterinary_managment/view/product_details_page.dart';
import 'package:veterinary_managment/view/qr_reader_page.dart';
import 'package:veterinary_managment/view/settings_page.dart';
import 'package:veterinary_managment/widget/k_text.dart';
import 'package:veterinary_managment/view/products_page.dart';
import 'package:veterinary_managment/widget/cards/main_card.dart';
import 'package:veterinary_managment/widget/cards/product_card.dart';

import 'add_product_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loading = ref.watch(productProvider);
    final product = ref.read(productProvider.notifier);
    final usd = ref.read(usdProvider.notifier);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const KText("الرئيسية"),
          centerTitle: true,
          leading: IconButton(
            onPressed: (){
              NavigatorHelper.push(context, const SettingsPage());
            },
            icon: const Icon(Icons.settings),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MainCard(
                        title: "عدد المنتجات الموجودة",
                        number: (product.productCount??0).toString(),
                      ),
                      MainCard(
                        title: "عدد الانواع الموجودة",
                        number: product.products.length.toString(),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MainCard(
                        title: "الاجمالي بالليرة",
                        number: MathHelper.roundDecimal(product.totalPrice! * usd.usdPrice),
                      ),
                      MainCard(
                        title: "الاجمالي بالدولار",
                        number: MathHelper.roundDecimal(product.totalPrice!),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const KText(
              "المضاف حديثاً",
            ),
            Expanded(
              flex: 5,
              child: Card(
                child: loading ?
                const Center(child: CircularProgressIndicator(),) :
                ListView.builder(
                  itemCount: product.products.length > 4 ? 4 : product.products.length,
                  itemBuilder: (context, i){
                    return ProductCard(
                      product: product.products.reversed.toList()[i],
                    );
                  },
                ),
              ),
            ),
            TextButton(
              onPressed: (){
                NavigatorHelper.push(context, const ProductsPage());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  KText(
                    "المزيد",
                    color: AppPattern.mainColor,
                  ),
                  const Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            NavigatorHelper.push(
              context,
              QrReaderPage(
                onResult: (val){
                  _checkProduct(context, val);
                },
              ),
            );
          },
          child: const Icon(Icons.qr_code),
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  void _checkProduct(BuildContext context, String? productID) async{

    if(productID == null) return;
    var box = Hive.box('products');

    dynamic product = box.get(productID);

    if(product == null){
      NavigatorHelper.push(
        context,
        AddProductPage(product: product),
      );
    }else{
      NavigatorHelper.push(
        context,
        ProductDetailsPage(product: product),
      );
    }
  }
}