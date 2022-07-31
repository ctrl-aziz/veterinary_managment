import 'package:hive/hive.dart';
part 'product.g.dart';

@HiveType(typeId: 0)
class Product extends HiveObject{
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  int? count;
  @HiveField(3)
  double? price;

  Product({
    required this.id,
    required this.name,
    required this.count,
    required this.price,
  });

  Product.fromJson(Map json){
    id = json["id"];
    name = json["name"];
    count = json["count"];
    price = json["price"];
  }

}