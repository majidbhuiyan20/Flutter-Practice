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

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _productCodeController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitPriceController = TextEditingController();
  final _imageUrlController = TextEditingController();

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
            key: _formKey,
            child: Column(
          children: [
            SizedBox(height: 10,),
            TextFormField(
              textInputAction: TextInputAction.next,
              controller: _productNameController,
              decoration: InputDecoration(
                labelText: "Product Name",
                focusColor: Colors.blue,
                hoverColor: Colors.blue,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter product name';
                }
                return null;
              },
            ),
            SizedBox(height: 10,),
            TextFormField(
              textInputAction: TextInputAction.next,
              controller: _productCodeController,
              decoration: InputDecoration(
                labelText: "Product Code",
                focusColor: Colors.blue,
                hoverColor: Colors.blue,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter product code';
                }
                return null;
              },
            ),
            SizedBox(height: 10,),
            TextFormField(
              textInputAction: TextInputAction.next,
              controller: _quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Quantity",
                focusColor: Colors.blue,
                hoverColor: Colors.blue,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),

              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter quantity';
                }
                return null;
              },
            ),
            SizedBox(height: 10,),
            TextFormField(
              controller: _unitPriceController,
              textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Unit Price",
                focusColor: Colors.blue,
                hoverColor: Colors.blue,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
              //keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter unit price';
                }
                return null;
              },
            ),
            SizedBox(height: 10,),

            TextFormField(
              keyboardType: TextInputType.number,
              controller: _imageUrlController,
              decoration: InputDecoration(
                labelText: "Img url",
                focusColor: Colors.blue,
                hoverColor: Colors.blue,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter image URL';
                }
                return null;
              },
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
                  onPressed: (){
                    if(_formKey.currentState!.validate()){


                    }
                  }, child: Text("Add Product", style: TextStyle(color: Colors.white, fontSize: 16),)),
            ),

          ],
        )),
      ),

    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _productNameController.dispose();
    _productCodeController.dispose();
    _quantityController.dispose();
    _unitPriceController.dispose();
    _imageUrlController.dispose();
    super.dispose();


  }
}