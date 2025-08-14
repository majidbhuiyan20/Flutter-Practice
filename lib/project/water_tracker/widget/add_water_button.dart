import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class addWaterButton extends StatelessWidget {
  const addWaterButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: () {},
        label: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Text('Add 100LTR', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
        ),
        icon: Icon(Icons.water_drop, color: Colors.white, size: 28,),
      ),
    );
  }
}
