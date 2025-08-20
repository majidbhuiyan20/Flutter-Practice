import 'package:flutter/material.dart';
import 'package:practice/project/crud_app/update_product_screen.dart';
class product_item extends StatelessWidget {
  const product_item({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
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
            trailing: PopupMenuButton<productOptions>(itemBuilder: (context){
              return [PopupMenuItem(
                value: productOptions.update,
                child: Text("Update"),),
                PopupMenuItem(
                  value: productOptions.delete,
                  child: Text("Delete"),)];
            },
              onSelected: (productOptions selectedOption){
                if(selectedOption == productOptions.delete){
                  print("delete");
                }
                else if(selectedOption == productOptions.update){
                  print("Update");
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> UpdateProductScreen()));
                }
              },

            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            indent: 70,
          );
        }
    );
  }
}

//Test
enum productOptions{
  update,
  delete,
}
