import 'dart:ffi';

class ProductDataModel {
  //data Type
  int? id;
  String? title;
  int? price;
  String? imageUrl;
  int? count;
  bool? isAuction;
  String? description;

  // constructor
  ProductDataModel(
      {this.id,
      this.title,
      this.price,
      this.imageUrl,
      this.count,
      this.isAuction,
      this.description});
  //method that assign values to respective datatype vairables
  ProductDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    price = json['price'];
    imageUrl = json['imageUrl'];
    count = json['count'];
    isAuction = json['isAuction'];
    description = json['description'];
  }
}
