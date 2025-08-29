// "_id": "68af6129dd287e3f18a26813",
// "ProductName": "Kola",
// "ProductCode": 83468236,
// "Img": "kola.com",
// "Qty": 80,
// "UnitPrice": 8,
// "TotalPrice": 640
class ProductsModel{
  late String id;
  late String name;
  late int code;
   String ? image;
  late int quantity;
  late int unitPrice;
  late int totalPrice;

  ProductsModel.fromJson(Map<String, dynamic> productJson){
    id = productJson['_id'];
    name = productJson['ProductName'];
    code = productJson['ProductCode'];
    quantity = productJson['Qty'];
    unitPrice = productJson['UnitPrice'];
    totalPrice = productJson['TotalPrice'];
    image = productJson['Img'];
  }
}

