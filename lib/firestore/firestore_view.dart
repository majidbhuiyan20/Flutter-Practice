import 'package:flutter/material.dart';
import 'firestore_send_data.dart';
import 'firestore_fetch_data.dart';


class FirestoreView extends StatefulWidget {
  const FirestoreView({super.key});

  @override
  State<FirestoreView> createState() => _FirestoreViewState();
}

class _FirestoreViewState extends State<FirestoreView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        title: const Text(
          "Firestore",
          style: TextStyle(
            color: Colors.white,
          ),

        ),
    ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 150,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.blueAccent, Colors.lightBlueAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Card(
                    color: Colors.transparent, // Make card transparent to show gradient
                    elevation: 0, // Remove card elevation as container has shadow
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return const FirestoreFetchData();
                        }));
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: Text("Fetch Data", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white))),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8), // Spacing between cards
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.green, Colors.lightGreenAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Card(
                    color: Colors.transparent,
                    elevation: 0,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return const FirestoreSendData();
                        }));
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: Text("Send Data", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white))),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }



}
