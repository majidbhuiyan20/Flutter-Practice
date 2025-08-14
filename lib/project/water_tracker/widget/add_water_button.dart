import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class addWaterButton extends StatelessWidget {
  final int amount;
  String ? text;
  IconData? icon;
  final VoidCallback callBack;

   addWaterButton({this.text,
    super.key, required this.amount,this.icon, required this.callBack
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: callBack,
        label: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Text('${text ?? "ADD"} $amount LTR', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
        ),
        icon: Icon(icon ?? Icons.water_drop, color: Colors.white, size: 28,),
      ),
    );
  }
}
