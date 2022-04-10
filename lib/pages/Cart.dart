import 'dart:convert';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:vezdecode_flutetr/product_data_model.dart';
import 'package:flutter/services.dart' as rootBundle;

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final db = Localstore.instance;

  List<dynamic> cart = [];

  List<ProductDataModel> products = [];

  final AsyncMemoizer _memoizer = AsyncMemoizer();

  ReadJsonData() async {
    return this._memoizer.runOnce(() async {
      final jsondata =
          await rootBundle.rootBundle.loadString('configs/products.json');

      final list = json.decode(jsondata) as List<dynamic>;

      final _products = list.map((e) => ProductDataModel.fromJson(e)).toList();

      setState(() {
        for (int i = 0; i < _products.length; i++) {
          if (cart.indexOf(_products[i].id as int) != -1)
            products.add(_products[i]);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    db.collection('cart').doc('cart').get().then((value) {
      bool isFirst = true;

      setState(() {
        value?.values.forEach((element) {
          if (isFirst) cart = element;
          isFirst = false;
        });
      });
    });

    return Scaffold(
      body: FutureBuilder(
          future: ReadJsonData(),
          builder: (context, data) {
            return Padding(
              padding: EdgeInsets.all(20),
              child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(999),
                                child: Image.network(
                                  products[index].imageUrl ?? '/',
                                  width: 80,
                                  height: 80,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  '${products[index].title?.substring(0, products[index].title!.length > 10 ? 10 : products[index].title?.length)}...' ??
                                      'Title',
                                  style: TextStyle(fontSize: 16),
                                  softWrap: true,
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                '${products[index].price} \$' ?? 'price',
                                style: TextStyle(fontSize: 16),
                                softWrap: true,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: ElevatedButton(
                                  onPressed: () {
                                    db
                                        .collection('cart')
                                        .doc('cart')
                                        .get()
                                        .then((value) {
                                      bool isFirst = true;
                                      value?.values.forEach((element) {
                                        if (isFirst) {
                                          var elems = [...element];
                                          elems.remove(products[index].id);
                                          db
                                              .collection('cart')
                                              .doc('cart')
                                              .set({'cart': elems});
                                        }
                                        isFirst = false;
                                      });
                                    });
                                    Navigator.pushNamed(
                                      context,
                                      '/cart',
                                    );
                                  },
                                  child: Icon(Icons.highlight_remove_outlined),
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.redAccent),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  }),
            );
          }),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.shop), label: 'Магазин'),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_shopping_cart_rounded), label: 'Корзина')
        ],
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(
              context,
              '/',
            );
          }
        },
      ),
    );
  }
}
