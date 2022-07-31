import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:veterinary_managment/model/product.dart';
import 'package:veterinary_managment/provider/app_provider.dart';
import 'package:veterinary_managment/utilities/math_helper.dart';
import 'package:veterinary_managment/utilities/navigator_helper.dart';
import 'package:veterinary_managment/view/product_details_page.dart';
import 'package:veterinary_managment/widget/k_text.dart';

class ProductCard extends ConsumerWidget {
  final Product product;
  const ProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usd = ref.read(usdProvider.notifier);
    return Card(
      child: ListTile(
        onTap: (){
          NavigatorHelper.push(context, ProductDetailsPage(product: product,));
        },
        leading: const Icon(Icons.qr_code_2),
        title: KText(
          product.name??"",
        ),
        subtitle: Directionality(
          textDirection: TextDirection.ltr,
          child: KText(
            "${MathHelper.roundDecimalDouble(product.price! * usd.usdPrice)} SP | \$ ${product.price}",
            textType: TextType.number,
            textAlign: TextAlign.end,
          ),
        ),
        trailing: Column(
          children: [
            const KText(
              "العدد",
            ),
            KText(
              product.count.toString(),
              textType: TextType.number,
            ),
          ],
        ),
      ),
    );
  }
}