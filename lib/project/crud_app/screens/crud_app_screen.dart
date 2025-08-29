import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:practice/project/crud_app/models/products_model.dart';
import 'package:practice/project/crud_app/screens/add_new_product_screen.dart';
import 'package:practice/project/crud_app/utils/urls.dart';
import 'package:practice/project/crud_app/widgets/product_item.dart';

class CrudAppScreen extends StatefulWidget {
  const CrudAppScreen({super.key});

  @override
  State<CrudAppScreen> createState() => _CrudAppScreenState();
}

class _CrudAppScreenState extends State<CrudAppScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getProductList();
  }

  final List<ProductsModel> _productList = [];
  bool _getProductInProgress = false;

  Future<void> _getProductList() async{
    _productList.clear();
    _getProductInProgress = true;
    setState(() {

    });
    Uri uri = Uri.parse(Urls.getProductUrl);
    Response response = await  get(uri);

    debugPrint(response.statusCode.toString());
    debugPrint(response.body);


    if(response.statusCode == 200){
      final decodedJson = jsonDecode(response.body);
      for(Map<String, dynamic> productJson in decodedJson['data']){

    ProductsModel productsModel = ProductsModel.fromJson(productJson);
    _productList.add(productsModel);
      }
    }
    _getProductInProgress = false;
    setState(() {
    });

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
        actions: [
          IconButton(onPressed: (){
            _getProductList();
          }, icon: Icon(Icons.refresh, color: Colors.white,),)

        ],
      ),
      body: Visibility(
        visible: _getProductInProgress == false,
        replacement: Center(
          child: CircularProgressIndicator(),
        ),
        child: ListView.builder(
          itemCount: _productList.length,
            itemBuilder: (context, index){
              return product_item(product: _productList[index]);
            }
        ),
      ),
      // body: product_item(product: _productList[index]),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> AddNewProductScreen()));
        },
        backgroundColor: Colors.blue,
      child: Icon(Icons.add, color: Colors.white),
      ),

    );
  }
}
