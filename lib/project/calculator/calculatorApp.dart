import 'package:flutter/material.dart';
import 'package:practice/project/calculator/widget/buildCalculatorButton.dart';

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({super.key});

  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {

  String _output = '0';
  String _input = '0';
  String _operator = '0';
  double num1 = 0;
  double num2 = 0;

void buttonPressed(String value){
  print("Print Vlaue: $value");

  setState(() {
    if(value == 'C'){
     _output = '0';
     _input = '0';
     _operator = '';
     num1 = 0;
     num2 = 0;
    }
    else if(value == '='){
      num2 = double.parse(_input);
      if(_operator == '+'){
        _output = (num1 + num2).toString();
      }
      else if(_operator == '-'){
        _output = (num1 - num2).toString();
      }
      else if(_operator == '*'){
        _output = (num1 * num2).toString();
      }
      else if(_operator == '/'){
        _output = num2 !=0 ? (num1 / num2).toString(): "Error";

      }
    }
    else if(value == '+' || value == '-' || value == '*' || value == '/'){
      num1 = double.parse(_input);
      _operator = value;
      _input = '';
    }
    else{
      if(_input == '0'){
        _input = value;
      }
      else
        {
          _input += value;
        }
      _output = _input;
    }

  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(_output, style: TextStyle(fontSize: 50, color: Colors.white, fontWeight: FontWeight.bold),),
                ],
              ),
            ),
            Row(
              children: [
                buildCalculatorButton(onClick:()=> buttonPressed('7'), text: '7', color: null,),
                buildCalculatorButton(onClick:()=> buttonPressed('8'), text: '8', color: null,),
                buildCalculatorButton(onClick:()=> buttonPressed('9'), text: '9', color: null,),
                buildCalculatorButton(onClick:()=> buttonPressed('/'), text: '/', color: Colors.orange,),
              ],
            ),
            Row(
              children: [
                buildCalculatorButton(onClick:()=> buttonPressed('4'), text: '4', color: null,),
                buildCalculatorButton(onClick:()=> buttonPressed('5'), text: '5', color: null,),
                buildCalculatorButton(onClick:()=> buttonPressed('6'), text: '6', color: null,),
                buildCalculatorButton(onClick:()=> buttonPressed('*'), text: '*', color: Colors.orange,),
              ],
            ),
            Row(
              children: [
                buildCalculatorButton(onClick:()=> buttonPressed('3'), text: '3', color: null,),
                buildCalculatorButton(onClick:()=> buttonPressed('2'), text: '2', color: null,),
                buildCalculatorButton(onClick:()=> buttonPressed('1'), text: '1', color: null,),
                buildCalculatorButton(onClick:()=> buttonPressed('-'), text: '-', color: Colors.orange,),
              ],
            ),
            Row(
              children: [
                buildCalculatorButton(onClick:()=> buttonPressed('C'), text: 'C', color: null,),
                buildCalculatorButton(onClick:()=> buttonPressed('0'), text: '0', color: null,),
                buildCalculatorButton(onClick:()=> buttonPressed('='), text: '=', color: null,),
                buildCalculatorButton(onClick:()=> buttonPressed('+'), text: '+', color: Colors.orange,),
              ],
            )
            ],
        ),
      ),
    );
  }
}
