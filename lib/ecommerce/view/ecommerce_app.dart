import 'package:flutter/material.dart';
import 'package:practice/ecommerce/view/product_view.dart';

class EcommerceApp extends StatefulWidget {
  const EcommerceApp({super.key});

  @override
  State<EcommerceApp> createState() => _EcommerceAppState();
}

class _EcommerceAppState extends State<EcommerceApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Ecommerce", style: TextStyle(color: Colors.white),),
          leading: BackButton(color: Colors.white,),
          backgroundColor: Colors.blue,
        ),
        body: Padding(
          padding:  EdgeInsets.all(16.0),
          child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (_)=>ProductView()));
                  },
                  child: Container(
                    width: 150,
                    height: 150,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(child: Text("Product List", style: TextStyle(fontWeight: FontWeight.bold),)),
                  ),
                ),
                SizedBox(width: 30,),
                InkWell(
                  onTap: (){

                  },
                  child: Container(
                    width: 150,
                    height: 150,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(child: Text("Add Product", style: TextStyle(fontWeight: FontWeight.bold),)),
                  ),
                )
              ],
            )
                ],
              ),
        ),
    );
  }
}
