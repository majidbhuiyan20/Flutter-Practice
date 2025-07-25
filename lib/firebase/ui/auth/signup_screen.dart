import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:practice/firebase/widgets/round_button.dart';
import 'package:practice/firebase/ui/auth/login_screen.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscureText = true;
  bool loading = false;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  void signup() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty || nameController.text.isEmpty) {
      Utils.toastMessage("Name, Email and Password must not be empty");
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      // Utils.toastMessage("Signup Successful"); // Replaced with SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signup Successful! Please login.')),
      );
      // Navigate to login screen after successful signup
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = "This email is already in use.";
          break;
        case 'invalid-email':
          errorMessage = "This email address is invalid.";
          break;
        case 'weak-password':
          errorMessage = "Password should be at least 6 characters.";
          break;
        default:
          errorMessage = "Signup failed. ${e.message}";
      }
      Utils.toastMessage(errorMessage);
    } catch (e) {
      Utils.toastMessage("Unexpected error: $e");
    } finally {
      setState(() {
        loading = false;
      });
    }
  }





  @override
  Widget build(BuildContext context) {
    print("This is majid");
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.blue,
        title: Text(
          "SignUp",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: loading
              ? MainAxisAlignment.center
              : MainAxisAlignment.center, // Center content when loading
          children: [
            // if (loading)
            //   CircularProgressIndicator(), // Show progress indicator when loading
            // if (!loading) // Only show the form if not loading
            Form(key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: "Name", // Text "Name" color is not directly settable here
                      hintText: "Enter your name", // Hint text color is not directly settable here
                      prefixIcon: Icon(Icons.person, color: Colors.blue),
                      border: OutlineInputBorder( // Rounded borders
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100], // Light background
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your name";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email", // Text "Email" color is not directly settable here
                      hintText: "Enter your email", // Hint text color is not directly settable here
                      prefixIcon: Icon(Icons.email, color: Colors.blue),
                      border: OutlineInputBorder( // Rounded borders
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.blue, width: 2),
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
                      labelText: "Password", // Text "Password" color is not directly settable here
                      hintText: "Enter your Password", // Hint text color is not directly settable here
                      prefixIcon: Icon(Icons.password, color: Colors.blue),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                      ),
                      border: OutlineInputBorder( // Rounded borders
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.blue, width: 2),
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
            // if (!loading) // Only show buttons if not loading
              SizedBox(
                height: 20,
              ),
            RoundButton(
              title: "Sign Up",
              loading: loading,
              color: Colors.blue, // Set the button color to blue
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  signup();
                }
              },
            ),
            Row(
                key: ValueKey<bool>(!loading), // Add a key to ensure proper rebuild
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?"),
                  TextButton( // Text color for TextButton's child is blue by default
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => LoginScreen()));
                      },
                      child: Text("Login", style: TextStyle(color: Colors.blue)))
                ],
              ),

          ],
        ),
      ),
    );
  }
}


class Utils {
  static void toastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }
}