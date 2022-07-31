import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:veterinary_managment/model/product.dart';
import 'package:veterinary_managment/pattern.dart';
import 'package:veterinary_managment/provider/app_provider.dart';
import 'package:veterinary_managment/provider/product_provider.dart';
import 'package:veterinary_managment/utilities/math_helper.dart';
import 'package:veterinary_managment/utilities/navigator_helper.dart';
import 'package:veterinary_managment/view/add_product_page.dart';
import 'package:veterinary_managment/widget/cards/details_card.dart';
import 'package:veterinary_managment/widget/k_text.dart';

class ProductDetailsPage extends ConsumerStatefulWidget {
  final Product product;
  const ProductDetailsPage({Key? key, required this.product}) : super(key: key);

  @override
  ConsumerState<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends ConsumerState<ProductDetailsPage> {
  Product? editedProduct;
  
  
  @override
  Widget build(BuildContext context) {
    final usd = ref.read(usdProvider.notifier);
    final product = ref.read(productProvider.notifier);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const KText(
              "التفاصيل"
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            children: [
              (editedProduct ?? widget.product).id == null?
              const Icon(Icons.qr_code_2, size: 300,):
              BarcodeWidget(
                barcode: Barcode.code128(),
                data: (editedProduct ?? widget.product).id!,
                width: 320,
                color: AppPattern.secondaryColor!,
                style: TextStyle(
                  fontFamily: "Lemonada",
                  color: AppPattern.secondaryColor!,
                ),
              ),
              DetailsCard(title: "اسم الدواء:", subTitle: (editedProduct ?? widget.product).name??""),
              DetailsCard(title: "السعر بالليرة:", subTitle: MathHelper.roundDecimalDouble(((editedProduct ?? widget.product).price??0) * usd.usdPrice)),
              DetailsCard(title: "السعر بالدولار:", subTitle: (editedProduct ?? widget.product).price.toString()),
              DetailsCard(title: "العدد:", subTitle: (editedProduct ?? widget.product).count.toString()),
              Padding(
                padding: EdgeInsets.symmetric(vertical: AppPattern.kPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: (){
                        NavigatorHelper.push(
                          context,
                          AddProductPage(
                            product: (editedProduct ?? widget.product),
                            callback: (Product prdct){
                              setState(() {
                                editedProduct = prdct;
                              });
                            },
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppPattern.kPadding),
                        child: KText("تعديل", color: AppPattern.mainColor,),
                      ),
                    ),
                    TextButton(
                      onPressed: () async{
                        Box<Product> box = Hive.box<Product>('products');
                        try{
                          product.setLoading();
                          await box.delete((editedProduct ?? widget.product).id).then((value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: KText("تم الحذف بنجاح"),
                              ),
                            );
                            product.getProducts();
                            Navigator.of(context).pop();
                          });
                        }catch(e){
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: KText("هنالك خطأ"),
                            ),
                          );
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppPattern.kPadding),
                        child: KText(
                          "حذف",
                          color: AppPattern.secondaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



