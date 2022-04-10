import 'package:flutter/material.dart';
import 'package:vezdecode_flutetr/pages/Cart.dart';
import 'package:vezdecode_flutetr/pages/Home.dart';
import 'package:vezdecode_flutetr/pages/Product.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'VK Shop',
    initialRoute: '/',
    routes: {
      '/': (context) => HomePage(),
      '/product': (context) => ProductPage(),
      '/cart': (context) => CartPage(),
    },
  ));
}
