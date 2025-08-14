
import 'package:flutter/material.dart';

class buildCalculatorButton extends StatelessWidget {
  const buildCalculatorButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(15),
            shape:RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            backgroundColor: Colors.grey[800],
          ),
          onPressed: (){}, child: Text("1", style: TextStyle(color: Colors.white, fontSize: 25,fontWeight: FontWeight.bold),)),
    );
  }
}
