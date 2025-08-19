import 'package:flutter/material.dart';
import 'package:practice/project/crud_app/add_new_product_screen.dart';

class CrudAppScreen extends StatefulWidget {
  const CrudAppScreen({super.key});

  @override
  State<CrudAppScreen> createState() => _CrudAppScreenState();
}

class _CrudAppScreenState extends State<CrudAppScreen> {
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
      body: ListView.separated(
          itemCount: 10,
          itemBuilder: (context, index){
        return ListTile(
          leading: CircleAvatar(),
          title: const Text("Product Name"),
          subtitle:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Code: 65dghs65"),
              Row(
                spacing: 16,
                children: [
                  Text("Quantity"),
                  Text("Unit Price"),
                ],

              ),
            ],
            
          ),
        );
      },
        separatorBuilder: (context, index) {
            return Divider(
              indent: 70,
            );
        }
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> AddNewProductScreen()));
        },
        backgroundColor: Colors.blue,
      child: Icon(Icons.add, color: Colors.white),
      ),

    );
  }
}
