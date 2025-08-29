import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:practice/project/crud_app/models/products_model.dart';
import 'package:practice/project/crud_app/utils/urls.dart';

import '../widgets/snackbar_message.dart';

class UpdateProductScreen extends StatefulWidget {
  UpdateProductScreen({super.key, required this.product});

  final ProductsModel product;

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productCodeController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _unitPriceController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  bool _updateProductInProgress = false;

  @override
  void initState() {
    super.initState();
    _productNameController.text = widget.product.name;
    _productCodeController.text = widget.product.code.toString();
    _quantityController.text = widget.product.quantity.toString();
    _unitPriceController.text = widget.product.unitPrice.toString();
    _imageUrlController.text = widget.product.image!;
  }

  Future<void> _updateProduct() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _updateProductInProgress = true;
    });

    try {
      String url = Urls.updateProductUrl(widget.product.id);
      print("Constructed URL: $url");

      Uri uri = Uri.parse(url);

      double totalPrice = double.parse(_unitPriceController.text) * double.parse(_quantityController.text);

      Map<String, dynamic> requestBody = {
        "ProductName": _productNameController.text.trim(),
        "ProductCode": int.parse(_productCodeController.text.trim()),
        "Img": _imageUrlController.text.trim(),
        "Qty": int.parse(_quantityController.text.trim()),
        "UnitPrice": double.parse(_unitPriceController.text.trim()),
        "TotalPrice": totalPrice,
      };

      print("Request URL: ${uri.toString()}");
      print("Request Body: ${jsonEncode(requestBody)}");

      Response response = await post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      print("POST Response Status: ${response.statusCode}");
      print("POST Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(response.body);
        print("Response JSON: $decodedJson");

        if (decodedJson['status'] == 'success') {
          final data = decodedJson['data'];

            showSnackBarMessage(context, "Product Updated Successfully");
            Navigator.pop(context, true);
        } else {
          final errorMessage = decodedJson['message'] ?? "Unknown error occurred";
          showSnackBarMessage(context, errorMessage);
        }
      } else {
        showSnackBarMessage(context, "Failed to update product. Server returned ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
      showSnackBarMessage(context, "An error occurred: ${e.toString()}");
    } finally {
      setState(() {
        _updateProductInProgress = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Update Product", style: TextStyle(color: Colors.white),),
        leading: const BackButton(color: Colors.white),
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
                    decoration:  InputDecoration(
                        hintText: "Product Name",
                        labelText: "Product Name",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)
                        )
                    ),
                    validator: (value){
                      if(value == null || value.trim().isEmpty){
                        return "Enter product name";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
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
                            borderSide: BorderSide(color: Colors.blue)
                        )
                    ),
                    validator: (value){
                      if(value == null || value.trim().isEmpty){
                        return "Enter product code";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _quantityController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    decoration:  InputDecoration(
                        hintText: "Quantity",
                        labelText: "Quantity",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)
                        )
                    ),
                    validator: (value){
                      if(value == null || value.trim().isEmpty){
                        return "Enter product quantity";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
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
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)
                        )
                    ),
                    validator: (value){
                      if(value == null || value.trim().isEmpty){
                        return "Enter product unit price";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
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
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)
                        )
                    ),
                    validator: (value){
                      if(value == null || value.trim().isEmpty){
                        return "Enter product image url";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20,),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        ),
                        onPressed: (){
                          _updateProduct();
                        },
                        child: const Text("Update Product", style: TextStyle(color: Colors.white),)),
                  ),
                ],
              ),
            )),
      ),
    );
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