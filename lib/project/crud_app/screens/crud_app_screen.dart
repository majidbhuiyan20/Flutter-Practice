import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:practice/project/crud_app/models/products.dart';
import 'package:practice/project/crud_app/screens/add_new_product_screen.dart';
import 'package:practice/project/crud_app/utils/urls.dart';
import 'package:practice/project/crud_app/widgets/product_item.dart';

class CrudAppScreen extends StatefulWidget {
  const CrudAppScreen({super.key});

  @override
  State<CrudAppScreen> createState() => _CrudAppScreenState();
}

class _CrudAppScreenState extends State<CrudAppScreen> {

  List<Product> _productList = [];

  Future<void> _getProductList() async{
    Uri uri = Uri.parse(Urls.getProductUrl);
    get(uri);
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Product List",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: product_item(),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> AddNewProductScreen()));
        },
        backgroundColor: Colors.blue,
      child: Icon(Icons.add, color: Colors.white),
      ),

    );
  }
}
