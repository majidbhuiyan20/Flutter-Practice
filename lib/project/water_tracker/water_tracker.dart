import 'dart:async';

import 'package:flutter/material.dart';
import 'package:practice/project/water_tracker/widget/add_water_button.dart';

class WaterTracker extends StatefulWidget {
  const WaterTracker({super.key});

  @override
  State<WaterTracker> createState() => _WaterTrackerState();
}

class _WaterTrackerState extends State<WaterTracker> {
  int currentWaterInTank = 0;
  int targetWater = 2000;
  Timer ? _timer;
  bool _isSnackBarVisible = false;

  void waterAdd(int amount){
    setState((){
      currentWaterInTank = currentWaterInTank + amount;
      if(currentWaterInTank >= targetWater){
        currentWaterInTank = targetWater;
        if (!_isSnackBarVisible) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Text('Congratulations! You have reached your target.', style: TextStyle(color: Colors.white, fontSize: 16),),
            ),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        )
            .closed
            .then((SnackBarClosedReason reason) {
            setState(() {
              _isSnackBarVisible = false;
            });
          });
        _isSnackBarVisible = true;}
      }
      print(currentWaterInTank);
    });
  }
  void waterRemove(int amount){
    setState((){
      currentWaterInTank = currentWaterInTank - amount;
      if(currentWaterInTank <= 0){
        currentWaterInTank = 0;
        if (!_isSnackBarVisible) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.redAccent, // Changed color for empty tank
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Text('Your Water Tank is Empty.', style: TextStyle(color: Colors.white, fontSize: 16),),
              ),
              duration: Duration(seconds: 3),
              backgroundColor: Colors.transparent,
              elevation: 0,
            )
        )
            .closed
            .then((SnackBarClosedReason reason) {
            setState(() {
              _isSnackBarVisible = false;
            });
          });
          _isSnackBarVisible = true;
        }
      }
      print(currentWaterInTank);
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1 ), (timer) {

      setState(() {
        currentWaterInTank++;
        if(currentWaterInTank >= targetWater){
          currentWaterInTank = targetWater;

        }

      });
    } );


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Water Tracker', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        leading: const BackButton(color: Colors.white),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(80),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 10,
                    //offset: Offset(0, 9),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Today\'s in Tank',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    currentWaterInTank.toString(),
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 150,
                  width: 150,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    strokeWidth: 15,
                    color: Colors.blue,
                    strokeCap: StrokeCap.round,
                    value: currentWaterInTank / targetWater,
                  ),
                ),
                Text(
                  "${(currentWaterInTank / targetWater * 100).toStringAsFixed(0)}%",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Wrap(
                spacing: 1,
                children: [
                  addWaterButton(
                    amount: 100,
                    callBack: () => waterAdd(100),
                  ),
                  addWaterButton(
                    amount: 200,
                    callBack: () => waterAdd(200),
                    icon: Icons.water_drop_rounded,
                  ),
                  addWaterButton(
                    amount: 100,
                    callBack: () => waterRemove(100),
                    icon: Icons.water_drop_rounded,
                    text: "Sub",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
