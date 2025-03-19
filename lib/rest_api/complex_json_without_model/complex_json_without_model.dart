import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ComplexJsonWithoutModel extends StatefulWidget {
  const ComplexJsonWithoutModel({super.key});

  @override
  State<ComplexJsonWithoutModel> createState() => _ComplexJsonWithoutModelState();
}

class _ComplexJsonWithoutModelState extends State<ComplexJsonWithoutModel> {
  var data;

  Future<void> getUserAPI() async{
    final response = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/users")) ;
    if(response.statusCode == 200)
      {
        data = jsonDecode(response.body.toString());
      }
    else
      {
        print("Error");
      }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text(
          "Complex Json Without Model",
          style: TextStyle(
            color: Colors.white,
            fontWeight:FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: getUserAPI(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: Text("Loading..."));
                } else {
                  return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index){
                        return Card(
                          child: ListTile(
                            title: Text(data[index]['name']),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(data[index]['email']),
                                Text(data[index]['phone']),
                                SizedBox(height: 10,),
                                Text("City: "+data[index]['address']['city']),
                                 Text("Latitude: "+data[index]['address']['geo']['lat']),
                                 Text("Longitude: "+data[index]['address']['geo']['lng']),
                                 Text("Company Name: "+data[index]['company']['name']),
                          
                          
                          
                              ],
                            ),
                          ),
                        );
                  });
                }
              },
            ),
          ),
        ],
      )

    );
  }
}
