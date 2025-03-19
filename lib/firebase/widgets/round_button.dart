import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  String title;
  final VoidCallback onTap;
  RoundButton({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
