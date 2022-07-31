import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:veterinary_managment/provider/product_provider.dart';
import 'package:veterinary_managment/utilities/navigator_helper.dart';
import 'package:veterinary_managment/view/add_product_page.dart';
import 'package:veterinary_managment/widget/k_text.dart';
import 'package:veterinary_managment/widget/cards/product_card.dart';


class ProductsPage extends ConsumerWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loading = ref.watch(productProvider);
    final products = ref.read<ProductProvider>(productProvider.notifier).products;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const KText(
            "المنتجات",
          ),
          centerTitle: true,
        ),
        body: loading ?
        const Center(child: CircularProgressIndicator(),) :
        ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, i){
            return ProductCard(
              product: products.reversed.toList()[i],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            NavigatorHelper.push(context, const AddProductPage());
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

