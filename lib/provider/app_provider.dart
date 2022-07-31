import 'package:hive/hive.dart';
import 'package:riverpod/riverpod.dart';


class UsdPriceProvider extends StateNotifier<double>{
  UsdPriceProvider() : super(4060.0);

  bool editUsdPrice = false;
  String? newUsdPrice;



  double get usdPrice {
    var box = Hive.box('usdBox');

    var newPrice = box.get('price', defaultValue: 4060.0);
    state = newPrice;
    return state;
  }


  set usdPrice(val){
    state = val;
    var box = Hive.box('usdBox');

    box.put('price', state);
  }
}

final usdProvider = StateNotifierProvider((ref) => UsdPriceProvider(),);

