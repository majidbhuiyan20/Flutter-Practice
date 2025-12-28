import 'package:flutter/material.dart';
import 'package:practice/project/state_management/change_notifier/counter_controller.dart';
import 'package:practice/widgets/custom_appbar.dart';

class ChangeNotifierSecondScreen extends StatefulWidget {
  const ChangeNotifierSecondScreen({super.key, required this.counterController});

  final CounterController counterController;

  @override
  State<ChangeNotifierSecondScreen> createState() => _ChangeNotifierSecondScreenState();
}

class _ChangeNotifierSecondScreenState extends State<ChangeNotifierSecondScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: "Second Screen", backgroundColor: Colors.blue,),

      body: Center(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,

      children: <Widget>[
        const Text(
          'You have pushed the button this many times:',
        ),
        ListenableBuilder(
          listenable: widget.counterController,
          builder: (context, value) {
            return Text(
              '${widget.counterController.counter}',
              style: Theme.of(context).textTheme.headlineMedium,
            );
          }
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FloatingActionButton(
              onPressed: widget.counterController.decrement,
              child: const Icon(Icons.remove),
            ),
            FloatingActionButton(
              onPressed: widget.counterController.increment,
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ],
    ),
    ),
    );
  }
}
