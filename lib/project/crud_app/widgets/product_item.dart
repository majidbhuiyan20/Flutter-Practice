import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:practice/project/crud_app/screens/update_product_screen.dart';
import 'package:practice/project/crud_app/widgets/snackbar_message.dart';

import '../models/products_model.dart';
import '../utils/urls.dart';
class product_item extends StatefulWidget {
  const product_item({
    super.key, required this.product, required this.refreshProductList,
  });
  final ProductsModel product;
  final VoidCallback refreshProductList;

  @override
  State<product_item> createState() => _product_itemState();
}

class _product_itemState extends State<product_item> {
  bool _deleteInProgress = false;

  Widget build(BuildContext context) {
    final ProductsModel product = widget.product;
    return Visibility(
      visible: _deleteInProgress == false,
      replacement: Center(
        child: CircularProgressIndicator(),
      ),
      child: ListTile(
        leading: product.image != null
            ? Image.network(
                product.image!,
                width: 40,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.error_outline, size: 40);
                },
              )
            : Icon(Icons.error_outline, size: 40),
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
              _deleteProduct();
            } else if (selectedOption == productOptions.update) {
              print("Update");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UpdateProductScreen(product: widget.product,)));
            }
          },
        ),
      ),
    );
  }

  Future<void> _deleteProduct() async{
    setState(() {
      _deleteInProgress = true;
    });
    Uri uri = Uri.parse(Urls.deleteProductUrl(widget.product.id));
    Response response = await  get(uri);

    debugPrint(response.statusCode.toString());
    debugPrint(response.body);

    if(response.statusCode == 200){
      widget.refreshProductList();
    showSnackBarMessage(context, "Success Fully Deleted");
    } else {
      showSnackBarMessage(context, "Delete Field");
    }
    setState(() {
      _deleteInProgress = false;
    });
  }
}
enum productOptions{
  update,
  delete,
}