import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:practice/firebase/widgets/round_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    print("This is majid");
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple,
        title: Text(
          "SignUp",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "Enter your email",
                      prefixIcon: Icon(Icons.email, color: Colors.deepPurple),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12), // Rounded borders
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.deepPurple, width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100], // Light background
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email";
                      } else if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
                        return "Enter a valid email";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    obscureText: _obscureText,
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Enter your Password",
                      prefixIcon: Icon(Icons.password, color: Colors.deepPurple),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12), // Rounded borders
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.deepPurple, width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100], // Light background
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your password";
                      } else if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            RoundButton(title: "Login", onTap: (){
              if(_formKey.currentState!.validate()){

              }
            },),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?"),
                TextButton(onPressed: (){}, child: Text("Sign Up"))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
