import 'package:flutter/material.dart';
import 'package:practice/project/state_management/change_notifier/change_notifier_second_screen.dart';
import 'package:practice/project/state_management/change_notifier/counter_controller.dart';

class ChangeNotifierScreen extends StatefulWidget {
  const ChangeNotifierScreen({super.key});

  @override
  State<ChangeNotifierScreen> createState() => _ChangeNotifierScreenState();
}

class _ChangeNotifierScreenState extends State<ChangeNotifierScreen> {

  final CounterController counterController = CounterController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Notifier", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            ListenableBuilder(
              listenable: counterController,
              builder: (context, value) {
                return Text(
                  "${counterController.counter}",
                  style: Theme.of(context).textTheme.headlineMedium,
                );
              }
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  onPressed: counterController.decrement,
                  child: const Icon(Icons.remove),
                ),
                FloatingActionButton(
                  onPressed:  counterController.increment,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.navigate_next),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) =>  ChangeNotifierSecondScreen(counterController: counterController,)));
        },
      ),
    );
  }
}
