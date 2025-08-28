import 'package:flutter/material.dart';
import 'package:practice/project/crud_app/screens/update_product_screen.dart';

import '../models/products.dart';
class product_item extends StatelessWidget {
  const product_item({
    super.key, required this.product,
  });
  final Product product;

  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(),
      title: Text(product.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Code: ${product.code}"),
          Row(
            // spacing: 16, // Row does not have a spacing property, consider using SizedBox or Wrap
            children: [
              Text("Quantity:${product.quantity}"),
              SizedBox(width: 16), // Added SizedBox for spacing
              Text("Unit Price:${product.unitPrice}"),
            ],
          ),
        ],
      ),
      trailing: PopupMenuButton<productOptions>(
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              value: productOptions.update,
              child: Text("Update"),
            ),
            PopupMenuItem(
              value: productOptions.delete,
              child: Text("Delete"),
            ),
          ];
        },
        onSelected: (productOptions selectedOption) {
          if (selectedOption == productOptions.delete) {
            print("delete");
          } else if (selectedOption == productOptions.update) {
            print("Update");
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UpdateProductScreen()));
          }
        },
      ),
    );
  }
}

//Test
enum productOptions{
  update,
  delete,
}
//