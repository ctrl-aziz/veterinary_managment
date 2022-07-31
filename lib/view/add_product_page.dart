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
import 'package:veterinary_managment/view/qr_reader_page.dart';
import 'package:veterinary_managment/widget/k_input.dart';
import 'package:veterinary_managment/widget/k_text.dart';

class AddProductPage extends ConsumerStatefulWidget {
  final Product? product;
  final Function(Product)? callback;
  const AddProductPage({Key? key, this.product, this.callback}) : super(key: key);

  @override
  ConsumerState<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends ConsumerState<AddProductPage> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _syPriceController = TextEditingController();
  final TextEditingController _dPriceController = TextEditingController();
  final TextEditingController _countController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final usd = ref.read(usdProvider.notifier);
    final product = ref.read(productProvider.notifier);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: widget.product != null ? const KText("تعديل التفاصيل") : const KText("إضافة دواء جديد"),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _key,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      NavigatorHelper.push(
                        context,
                        QrReaderPage(
                          onResult: (val){
                            setState((){
                              product.productID = val;
                            });
                          },
                        ),
                      );
                    },
                    child: (product.productID ?? widget.product) == null ?
                    Icon(
                      Icons.camera,
                      color: AppPattern.lightGreenColor,
                      size: 300,
                    ):
                    BarcodeWidget(
                      barcode: Barcode.code128(),
                      data: (product.productID ?? widget.product!.id)!,
                      width: 320,
                      color: AppPattern.secondaryColor!,
                      style: TextStyle(
                        fontFamily: "Lemonada",
                        color: AppPattern.secondaryColor!,
                      ),
                    ),
                  ),
                  SizedBox(height: AppPattern.kPadding/2,),
                  if(!usd.editUsdPrice)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const KText("سعر الدولار: " , textType: TextType.text),
                        KText("${usd.usdPrice}" , textType: TextType.number,),
                      ],
                    )
                  else
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
                  GestureDetector(
                    onTap: (){
                      if(usd.editUsdPrice){
                        if(usd.newUsdPrice != null) {
                          product.setLoading();
                          usd.usdPrice = double.parse(usd.newUsdPrice!);
                          product.getProducts();
                        }
                      }
                      setState((){
                        usd.editUsdPrice = !usd.editUsdPrice;
                      });
                    },
                    child: KText(
                      usd.editUsdPrice ?
                      "حفظ" :
                      "تعديل",
                      color: AppPattern.secondaryColor!,
                    ),
                  ),
                  KInput(
                    "اسم الدواء",
                    controller: _nameController..text = widget.product != null ? widget.product!.name! : "",
                  ),
                  KInput(
                    "السعر بالليرة",
                    controller: _syPriceController..text = widget.product != null ? (widget.product!.price! * usd.usdPrice).toString() : "",
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.start,
                    onChanged: (val){
                      _dPriceController.text = MathHelper.roundDecimal(double.parse(_syPriceController.text.isEmpty ? "0" : _syPriceController.text) / usd.usdPrice);
                    },
                  ),
                  KInput(
                    "السعر بالدولار",
                    controller: _dPriceController..text = widget.product != null ? widget.product!.price.toString() : "",
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.start,
                    onChanged: (val){
                      _syPriceController.text = MathHelper.roundDecimal(double.parse(_dPriceController.text.isEmpty ? "0" : _dPriceController.text) * usd.usdPrice);
                    },
                  ),
                  KInput(
                    "العدد",
                    controller: _countController..text = widget.product != null ? widget.product!.count.toString() : "",
                    keyboardType: TextInputType.number,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.start,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: TextButton(
                      onPressed: (){
                        product.setLoading();
                        _key.currentState!.validate();
                        if((product.productID ?? widget.product) == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: KText("يرجى تسجيل كود المنتج"),
                            ),
                          );
                          return;
                        }
                        Product prdct = Product(
                          id: (product.productID ?? widget.product!.id),
                          name: _nameController.text,
                          count: int.parse(_countController.text),
                          price: double.parse(_dPriceController.text),
                        );
                        _addProduct(
                          prdct,
                        );
                        if(widget.callback != null) widget.callback!(prdct);
                        product.getProducts();
                        product.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                KText("تم الحفظ بنجاح"),
                              ],
                            ),
                          ),
                        );
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: KText("حفظ", color: AppPattern.mainColor,),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _addProduct(Product product){
    var box = Hive.box('products');

    box.put(product.id, product);
  }
}