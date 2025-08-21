import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class AddNewProductScreen extends StatefulWidget {
  const AddNewProductScreen({super.key});

  @override
  State<AddNewProductScreen> createState() => _AddNewProductScreenState();
}

class _AddNewProductScreenState extends State<AddNewProductScreen> {
  GlobalKey _formKey = GlobalKey<FormState>();
  TextEditingController _productNameController = TextEditingController();
  TextEditingController _productCodeController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _unitPriceController = TextEditingController();
  TextEditingController _imageUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: Text("Add New Product", style: TextStyle(color: Colors.white),),
            leading: BackButton(color: Colors.white),
          ),
      body:SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _productNameController,
                    decoration: InputDecoration(
                        hintText: "Product Name",
                        labelText: "Product Name",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.blue)
                        )
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _productCodeController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        hintText: "Product Code",
                        labelText: "Product Code",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.blue)
                        )
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _quantityController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText: "Quantity",
                        labelText: "Quantity",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.blue)
                        )
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _unitPriceController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText: "Unit Price",
                        labelText: "Unit Price",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.blue)
                        )
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _imageUrlController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        hintText: "Image Url",
                        labelText: "Image Url",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.blue)
                        )
                    ),
                  ),
                  SizedBox(height: 20,),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        ),
                        onPressed: (){
                            _onTapAddProductButton();
                        }, child: Text("Add Product", style: TextStyle(color: Colors.white),)),
                  ),
                ],
              ),
            )),
      ),
    );
  }

   Future<void> _onTapAddProductButton()async{
    //Prepare Uri to request
    
    Uri uri = Uri.parse("http://35.73.30.144:2008/api/v1/CreateProduct");
    double totalPrice = double.parse(_unitPriceController.text) * double.parse(_quantityController.text);
    Map<String, dynamic> requestBody =   {
      "ProductName": _productNameController.text,
    "ProductCode": _productCodeController.text,
    "Img": _imageUrlController.text,
    "Qty": _quantityController.text,
    "UnitPrice": _unitPriceController.text,
    "TotalPrice": totalPrice,
  };
    //Prepare data
    Response response = await post(uri, body: jsonEncode(requestBody));
    //Request with data
  }


  @override
  void dispose() {
    _productNameController.dispose();
    _productCodeController.dispose();
    _quantityController.dispose();
    _unitPriceController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }
}

