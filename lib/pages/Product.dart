import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final db = Localstore.instance;

  bool inMyCart = false;

  @override
  Widget build(BuildContext context) {
    final product =
        ModalRoute.of(context)!.settings.arguments as ProductPageArgument;

    db.collection('cart').doc('cart').get().then((value) {
      bool isFirst = true;
      value?.values.forEach((element) {
        if (isFirst && [...element].indexOf(product.id) != -1) {
          setState(() {
            inMyCart = true;
          });
        }
        isFirst = false;
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          product.title,
          style: const TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.blue),
        backgroundColor: Colors.white,
        shadowColor: Colors.black26,
      ),
      body: Column(
        children: [
          Image.network(
            product.imageUrl,
          ),
          Container(
            padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
            alignment: Alignment.topLeft,
            child: Text(
              product.title,
              style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w500),
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 5, right: 20, left: 20),
            alignment: Alignment.topLeft,
            child: Text(
              '${product.count} шт. в наличии',
              style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w500),
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 7, right: 20, left: 20),
            alignment: Alignment.topLeft,
            child: Text(
              product.isAuction ? 'Аукцион' : '${product.price} \$',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 15, right: 20, left: 20),
            alignment: Alignment.topLeft,
            child: Text(
              product.description,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    primary: inMyCart ? Colors.black12 : Colors.blue),
                onPressed: () {
                  if (!inMyCart) {
                    db.collection('cart').doc('cart').get().then((value) {
                      bool isFirst = true;
                      value?.values.forEach((element) {
                        if (isFirst) {
                          db.collection('cart').doc('cart').set({
                            'cart': [...element, product.id]
                          });
                        }
                        isFirst = false;
                      });
                    });
                  }
                },
                child: Text(
                  inMyCart ? 'Уже в корзине' : 'Добавить в корзину',
                )),
          )
        ],
      ),
    );
  }
}

class ProductPageArgument {
  final int id;
  final String title;
  final String imageUrl;
  final String description;
  final int price;
  final int count;
  final bool isAuction;

  ProductPageArgument(this.id, this.title, this.imageUrl, this.description,
      this.price, this.count, this.isAuction);
}
