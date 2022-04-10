import 'dart:convert';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:vezdecode_flutetr/components/ProductCard.dart';
import 'package:vezdecode_flutetr/product_data_model.dart';
import 'package:flutter/services.dart' as rootBundle;

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
        child: ListItems(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.shop), label: 'Магазин'),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_shopping_cart_rounded), label: 'Корзина')
        ],
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushNamed(
              context,
              '/cart',
            );
          }
        },
      ),
    );
  }
}

class ListItems extends StatefulWidget {
  @override
  _ListItemsState createState() => _ListItemsState();
}

class _ListItemsState extends State<ListItems> {
  List<List<Widget>> products = [];

  final AsyncMemoizer _memoizer = AsyncMemoizer();

  ReadJsonData() async {
    final jsondata =
        await rootBundle.rootBundle.loadString('configs/products.json');

    final list = json.decode(jsondata) as List<dynamic>;

    final _products = list.map((e) => ProductDataModel.fromJson(e)).toList();

    setState(() {
      for (int i = 0; i < _products.length; i++) {
        if (i % 2 == 0) {
          products.add([
            ProductCard(
                title: _products[i].title as String,
                imageUrl: _products[i].imageUrl as String,
                price: _products[i].price as int,
                productId: _products[i].id as int,
                description: _products[i].description as String,
                count: _products[i].count as int,
                isAuction: _products[i].isAuction as bool)
          ]);
        } else {
          products[products.length - 1].add(ProductCard(
              title: _products[i].title as String,
              imageUrl: _products[i].imageUrl as String,
              price: _products[i].price as int,
              productId: _products[i].id as int,
              description: _products[i].description as String,
              count: _products[i].count as int,
              isAuction: _products[i].isAuction as bool));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ReadJsonData(),
        builder: (context, data) {
          return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: products[index]));
              });
        });
  }
}
