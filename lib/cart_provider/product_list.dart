import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("Product List", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),),
        centerTitle: true,

        actions: [
          badges.Badge(
            badgeContent: Text(
              '0',
              style: TextStyle(color: Colors.white),
            ),
             // Correct animation type
            position: badges.BadgePosition.topEnd(top: -13, end: 15), // Adjust position
            child: Icon(Icons.shopping_bag_outlined, color: Colors.white),
          ),
        ],
      ),
    ));
  }
}
