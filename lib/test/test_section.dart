import 'package:flutter/material.dart';

class TestSection extends StatefulWidget {
  const TestSection({super.key});

  @override
  State<TestSection> createState() => _TestSectionState();
}

class _TestSectionState extends State<TestSection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Section'),
      ),
      body: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index){
        return ListTile(
          leading: CircleAvatar(),
          title: Text("Kola"),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Product Code"),
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
      }),
      floatingActionButton: FloatingActionButton(onPressed: (){
        print("Floating Action Button");
        Navigator.push(context, MaterialPageRoute(builder: (context)=>AddProductScreen()));
      },
        backgroundColor: Colors.blue,
      child: Icon(Icons.add, color: Colors.white,),
      ),
    );
  }
}

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Add Product', style: TextStyle(color: Colors.white),),
        leading: BackButton(color: Colors.white,),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
            child: Column(
          children: [
            SizedBox(height: 10,),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Product Name",
                focusColor: Colors.blue,
                hoverColor: Colors.blue,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ),
            SizedBox(height: 10,),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Product Code",
                focusColor: Colors.blue,
                hoverColor: Colors.blue,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ),
            SizedBox(height: 10,),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Quantity",
                focusColor: Colors.blue,
                hoverColor: Colors.blue,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ),
            SizedBox(height: 10,),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Unit Price",
                focusColor: Colors.blue,
                hoverColor: Colors.blue,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ),
            SizedBox(height: 10,),

            TextFormField(
              decoration: InputDecoration(
                labelText: "Img url",
                focusColor: Colors.blue,
                hoverColor: Colors.blue,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ),
            SizedBox(height: 10,),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: (){}, child: Text("Add Product", style: TextStyle(color: Colors.white, fontSize: 16),)),
            ),

          ],
        )),
      ),

    );
  }
}

