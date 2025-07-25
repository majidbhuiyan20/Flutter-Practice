import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:practice/rest_api/complex_json/model/user_model.dart';
import 'package:http/http.dart' as http;
class ComplexApi extends StatefulWidget {
  const ComplexApi({super.key});

  @override
  State<ComplexApi> createState() => _ComplexApiState();
}

class _ComplexApiState extends State<ComplexApi> {

  List<UserModel> userList = [];
  Future<List<UserModel>> getUserAPI() async{
    final response = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/users"));
     if(response.statusCode == 200){
       var data = jsonDecode(response.body);
       for(Map<String, dynamic> i in data){
         userList.add(UserModel.fromJson(i));
       }
       return userList;
     }
     else {
       return userList;
     }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        title: const Text(
          "COMPLEX API",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(child: FutureBuilder(future: getUserAPI(), builder: (context, snapshot){
            if(!snapshot.hasData){
              return Center(child: CircularProgressIndicator());
            }
            else{
              return ListView.builder(
                  itemCount: userList.length,
                  itemBuilder: (BuildContext context, int index){
                    return  Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                        elevation: 8,
                        color: Colors.black,
                        shadowColor: Colors.black54,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),

                      child: ListTileTheme(
                        textColor: Colors.white,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Text(snapshot.data![index].id.toString(), style: TextStyle(color: Colors.black),),
                          ),
                            title: Text(snapshot.data![index].name.toString(), style: TextStyle(color: Colors.white),),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(snapshot.data![index].email.toString()),
                              Text(snapshot.data![index].phone.toString()),
                              Text(snapshot.data![index].address!.city.toString()),
                              Text(snapshot.data![index].address!.geo!.lat.toString()),
                              Text("Car"),
                            ],
                          ),

                        ),
                      )));


                  });
            }
          }))
        ],
      ),
    );
  }
}
