import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:veterinary_managment/model/product.dart';
import 'package:veterinary_managment/utilities/hive_helper.dart';

class ProductProvider extends StateNotifier<bool>{
  ProductProvider() : super(true){
    init();
  }

  setLoading(){
    state = true;
  }

  String? productID;


  int? get productCount {
    if(products.isEmpty) return 0;
    return products.map((e) => e.count).reduce((value, element) => (value??0) + (element??0));
  }
  double? get totalPrice {
    if(products.isEmpty) return 0;
    return products.map((e) => e.price! * e.count!).reduce((a, b) => a + b);
  }

  Future<void> init() async {
    Hive.registerAdapter(ProductAdapter());
    await HiveHelper.openHiveBox('products');
    getProducts();
  }

  final List<Product> products = [];
  getProducts(){
    var box = Hive.box('products');
    products.clear();
    for (Product product in box.values) {
      products.add(product);
    }
    state = false;
  }

  void clear() {
    productID = null;
  }


}

final productProvider = StateNotifierProvider<ProductProvider, bool>((ref) => ProductProvider(),);
