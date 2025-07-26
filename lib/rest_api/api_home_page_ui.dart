import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
class ApiHomePageUi extends StatefulWidget {
  const ApiHomePageUi({super.key});

  @override
  State<ApiHomePageUi> createState() => _ApiHomePageUiState();
}

class _ApiHomePageUiState extends State<ApiHomePageUi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Examples'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: SizedBox(
                height: 150, // Standard card height
                width: 150,  // Standard card width
                child: Card(
                  elevation: 4,
                  child: InkWell(
                    onTap: () {
                      context.push('/complexApi');
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: Text('Complex API', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
