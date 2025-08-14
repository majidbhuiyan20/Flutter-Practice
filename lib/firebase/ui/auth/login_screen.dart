import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:practice/firebase/ui/auth/signup_screen.dart';
import 'package:practice/firebase/widgets/round_button.dart';
import 'package:practice/home_page/home_page_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscureText = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool loading = false;
  bool googleLoading = false; // Separate loading state for Google Sign-In

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void logIn() async{
    setState(() {
      loading = true;
    });
    try{
      final user = await _auth.signInWithEmailAndPassword(
          email: emailController.text.toString(),
          password: passwordController.text.toString());
      if(user.user != null){
        Utils.toastMessage("LogIn Successful");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool("isLoggedIn", true);
        if (mounted) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomePageScreen()));
        }
        setState(() {
          loading = false;
        });
      }
    }catch(e){
      Utils.toastMessage(e.toString());
      setState(() {
        loading = false; // Set loading to false on error to stop progress indicator
      });
    }
  }

  Future<void> signInWithGoogle() async {
    setState(() => googleLoading = true); // Use googleLoading for Google Sign-In

    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

      // Always sign out before starting to avoid cached account issues
      // await googleSignIn.signOut(); // Consider if this is always needed

      // Start Google Sign-In
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        Utils.toastMessage("Google Sign-In cancelled or failed.");
        if (mounted) setState(() => googleLoading = false);
        return;
      }

      // Get authentication tokens
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create Firebase credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      // Save login state
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool("isLoggedIn", true);

      Utils.toastMessage("✅ Google Sign-In Successful");

      if (!mounted) return;

      // Navigate to home
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePageScreen()),
      );
    } catch (e) {
      Utils.toastMessage("❌ Google Sign-In error: ${e.toString()}");
    } finally {
      // Ensure googleLoading is set to false in all cases
      if (mounted) setState(() => googleLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    // print("This is majid");
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        title: Text(
          "LogIn",
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
                  prefixIcon: Icon(Icons.email, color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded borders
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20), // Rounded focused border
                    borderSide: BorderSide(color: Colors.blue, width: 2), // Blue border when focused
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
                const SizedBox(height: 20),
                TextFormField(
                  obscureText: _obscureText,
                  controller: passwordController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Password",
                    hintText: "Enter your Password",
                    prefixIcon: Icon(Icons.password, color: Colors.blue),
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
            const SizedBox(height: 20),
            loading
                ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            )
                : RoundButton(
              title: "Login",
              color: Colors.blue,
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  logIn();
                }
              },
              loading: loading,
            ),
            const SizedBox(height: 20),
            // Google Sign-In Button
            Container(
              width: double.infinity,
              height: 50,
              child: googleLoading
                  ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                ),
              )
                  : ElevatedButton.icon(
                onPressed: loading ? null : signInWithGoogle, // Disable if email/password login is in progress
                icon: Icon(
                  Icons.g_mobiledata, // Google icon, consider using a more standard Google logo
                  color: Colors.white,
                  size: 24,
                ),
                label: Text(
                  "Sign in with Google",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple, // Changed Google Sign-In button color
                  disabledBackgroundColor: Colors.deepPurple.withOpacity(0.5), // Visual feedback when disabled
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
              ),

            ),
            const SizedBox(height: 20),
            Row(

              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account?"),
                TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> SignUpScreen()));
                }, child: Text("Sign Up"))
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


