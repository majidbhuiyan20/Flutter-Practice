import 'package:flutter/material.dart';

class CrudAppScreen extends StatefulWidget {
  const CrudAppScreen({super.key});

  @override
  State<CrudAppScreen> createState() => _CrudAppScreenState();
}

class _CrudAppScreenState extends State<CrudAppScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Product List",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),

    );
  }
}
