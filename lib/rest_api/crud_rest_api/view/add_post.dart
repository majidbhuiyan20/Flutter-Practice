import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:practice/rest_api/crud_rest_api/crud_api.dart';

import '../model/CrudUserModel.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();

  var apiURL = "http://localhost:3100/users/";
  Future<Users> createUser(Users user) async {
    final response = await http.post(
      Uri.parse(apiURL),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );
    if (response.statusCode == 201) {
      return Users.fromJson(jsonDecode(response.body));
    } else {
      return throw Exception("Failed Response");
    }
  }

  void _createUser() async {
    final users = Users(id: '', username: username.text, email: email.text);
    try{
      await createUser(users).then((value) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CrudApi()),
        );
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Successfully Inserted")));
      });
    }
    catch(error){
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text(
          "ADD POST",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Container(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: username,
                    keyboardType: TextInputType.text,

                    decoration: InputDecoration(
                      label: Text("User Name"),
                      hintText: "@UserName",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.indigo),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),

                  TextFormField(
                    controller: email,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      label: Text("Enter Email"),
                      hintText: "@example@gmail.com",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Colors.indigo),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      _createUser();
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.indigo,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          "Add Post",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
