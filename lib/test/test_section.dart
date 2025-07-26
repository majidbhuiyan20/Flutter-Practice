import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TestSection extends StatefulWidget {
  const TestSection({super.key});

  @override
  State<TestSection> createState() => _TestSectionState();
}

class _TestSectionState extends State<TestSection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Section'),
      ),
      body: const Center(
        child: Text('This is a Test Section.'),
      ),
    );
  }
}
