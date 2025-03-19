import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:practice/rest_api/crud_rest_api/model/CrudUserModel.dart';
import 'package:practice/rest_api/crud_rest_api/view/add_post.dart';
class CrudApi extends StatefulWidget {
  const CrudApi({super.key});

  @override
  State<CrudApi> createState() => _CrudApiState();
}

class _CrudApiState extends State<CrudApi> {

  Future<CrudUserModel> getUserCrudApi() async{
    final response = await http.get(Uri.parse("http://localhost:3100/users/"));
    
    if(response.statusCode == 200)
      {
        final data = jsonDecode(response.body);
        return CrudUserModel.fromJson(data);


      }
    else
      {
        return throw Exception("Error Data");
      }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
           "CRUD API",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Expanded(child: FutureBuilder(future: getUserCrudApi(), builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
            }
            else
              {
                return ListView.builder(
                    itemCount: snapshot.data!.users!.length,
                    itemBuilder: (context, index){
                 return Card(
                   child: ListTile(
                     leading: CircleAvatar(
                       backgroundColor: index.isEven ? Colors.purpleAccent : Colors.blue,
                       child: Text(
                         (index + 1).toString(),
                         style: TextStyle(
                           color: Colors.white,
                         ),
                       ),


                     ),
                     title: Text(snapshot.data!.users![index].username.toString()),
                     subtitle: Text(snapshot.data!.users![index].email.toString()),
                   ),
                 );
                });
              }
          }))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddPost()));
        },
        child: Icon(Icons.add),
      ),

    );
  }
}
