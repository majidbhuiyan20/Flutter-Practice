import 'package:flutter/material.dart';

class buildCalculatorButton extends StatelessWidget {
  String text;
  Color? color;
  final VoidCallback onClick;
  buildCalculatorButton({
    super.key,
    required this.onClick,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            backgroundColor: color ?? Colors.grey[800],
          ),
          onPressed: onClick,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
