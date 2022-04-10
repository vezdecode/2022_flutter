import 'package:flutter/material.dart';
import 'package:vezdecode_flutetr/pages/Product.dart';

class ProductCard extends StatelessWidget {
  final String title;
  final int price;
  final String imageUrl;
  final String description;
  final int productId;
  final int count;
  final bool isAuction;

  const ProductCard(
      {Key? key,
      required this.title,
      required this.price,
      required this.imageUrl,
      required this.description,
      required this.productId,
      required this.count,
      required this.isAuction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/product',
          arguments: ProductPageArgument(
              productId, title, imageUrl, description, price, count, isAuction),
        );
      },
      child: Container(
        width: 150,
        child: Column(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(imageUrl)),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                title,
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                isAuction ? 'Аукцион' : '$price \$',
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
