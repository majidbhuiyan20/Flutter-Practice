import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'firestore_fetch_data.dart';

class FirestoreSendData extends StatefulWidget {
  const FirestoreSendData({super.key});

  @override
  State<FirestoreSendData> createState() => _FirestoreSendDataState();
}

class _FirestoreSendDataState extends State<FirestoreSendData> {

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _universityController = TextEditingController();
  final _deptController = TextEditingController();

  Future<void> _submitData() async {
    if (_formKey.currentState!.validate()) {
      try {
        final user = FirebaseAuth.instance.currentUser;
        await FirebaseFirestore.instance.collection('students').add({
          'name': _nameController.text.trim(),
          'university': _universityController.text.trim(),
          'department': _deptController.text.trim(),
          'timestamp': FieldValue.serverTimestamp(),
          'userId': user!.uid,  // Add this line to store user ID
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Data submitted successfully!',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );

        _nameController.clear();
        _universityController.clear();
        _deptController.clear();

        // Navigate to FirestoreFetchData screen
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => const FirestoreFetchData()
        ));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error: $e',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Submit to Firestore')),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.purple.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Student Information',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildTextField(
                        controller: _nameController,
                        labelText: 'Name',
                        icon: Icons.person_outline,
                        validatorText: 'Please enter name',
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        controller: _universityController,
                        labelText: 'University',
                        icon: Icons.school_outlined,
                        validatorText: 'Please enter university',
                      ),
                      SizedBox(height: 16),
                      _buildTextField(
                        controller: _deptController,
                        labelText: 'Department',
                        icon: Icons.business_center_outlined,
                        validatorText: 'Please enter department',
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: _submitData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          textStyle: TextStyle(fontSize: 18, color: Colors.white),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          elevation: 5.0,
                        ),
                        child: Text(
                            'Submit',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    required String validatorText,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon, color: Theme.of(context).primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
        ),
        filled: true,
        fillColor: Colors.white70,
        contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
      ),
      validator: (value) => value!.isEmpty ? validatorText : null,
    );
  }
}
