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
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              child: Text("0", style: TextStyle(fontSize: 50, color: Colors.white, fontWeight: FontWeight.bold),),
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.all(20),
            ),
            Row(
              children: [
                buildCalculatorButton(onClick:(){}, text: '7', color: null,),
                buildCalculatorButton(onClick:(){}, text: '8', color: null,),
                buildCalculatorButton(onClick:(){}, text: '9', color: null,),
                buildCalculatorButton(onClick:(){}, text: '/', color: Colors.orange,),
              ],
            ),
            Row(
              children: [
                buildCalculatorButton(onClick:(){}, text: '4', color: null,),
                buildCalculatorButton(onClick:(){}, text: '5', color: null,),
                buildCalculatorButton(onClick:(){}, text: '6', color: null,),
                buildCalculatorButton(onClick:(){}, text: '*', color: Colors.orange,),
              ],
            ),
            Row(
              children: [
                buildCalculatorButton(onClick:(){}, text: '3', color: null,),
                buildCalculatorButton(onClick:(){}, text: '2', color: null,),
                buildCalculatorButton(onClick:(){}, text: '1', color: null,),
                buildCalculatorButton(onClick:(){}, text: '-', color: Colors.orange,),
              ],
            ),
            Row(
              children: [
                buildCalculatorButton(onClick:(){}, text: 'C', color: null,),
                buildCalculatorButton(onClick:(){}, text: '0', color: null,),
                buildCalculatorButton(onClick:(){}, text: '=', color: null,),
                buildCalculatorButton(onClick:(){}, text: '+', color: Colors.orange,),
              ],
            )
            ],
        ),
      ),
    );
  }
}
