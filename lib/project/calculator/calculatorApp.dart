import 'package:flutter/material.dart';
import 'package:practice/project/calculator/widget/buildCalculatorButton.dart';

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({super.key});

  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                buildCalculatorButton(),
              ],
            )
           
            ],
        ),
      ),
    );
  }
}
