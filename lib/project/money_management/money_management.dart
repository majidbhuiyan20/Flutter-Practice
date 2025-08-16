import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoneyManagement extends StatefulWidget {
  const MoneyManagement({super.key});

  @override
  State<MoneyManagement> createState() => _MoneyManagementState();
}

class _MoneyManagementState extends State<MoneyManagement>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Map<String, dynamic>> _earning = [];
  List<Map<String, dynamic>> _expense = [];

  double get totalExpanse => _expense.fold(0, (sum, item) => sum + item['amount']);
  double get totalEarning => _earning.fold(0, (sum, item) => sum + item['amount']);
  double get balance => totalEarning - totalExpanse;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final earningData = prefs.getStringList('earning') ?? [];
    final expenseData = prefs.getStringList('expense') ?? [];

    setState(() {
      _earning = earningData.map((item) {
        final decodedItem = jsonDecode(item);
        return {
          'title': decodedItem['title'],
          'amount': decodedItem['amount'],
          'date': DateTime.parse(decodedItem['date']),
        };
      }).toList();
      _expense = expenseData.map((item) {
        final decodedItem = jsonDecode(item);
        return {
          'title': decodedItem['title'],
          'amount': decodedItem['amount'],
          'date': DateTime.parse(decodedItem['date']),
        };
      }).toList();
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('earning', _earning.map((item) => jsonEncode({'title': item['title'], 'amount': item['amount'], 'date': item['date'].toIso8601String()})).toList());
    prefs.setStringList('expense', _expense.map((item) => jsonEncode({'title': item['title'], 'amount': item['amount'], 'date': item['date'].toIso8601String()})).toList());
  }

  void _showFABOptions(BuildContext context){
      showModalBottomSheet(context: context, builder: (context){
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: (){
                        Navigator.pop(context);
                        _showForm(isEarning: true);
                      }, child: Text("Add Income", style: TextStyle(color: Colors.white),)),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: (){
                        Navigator.pop(context);
                        _showForm(isEarning: false);
                      }, child: Text("Add Expense", style: TextStyle(color: Colors.white),)),
                ),
              ],
          ),
        );
      });
  }

  void _showForm({required bool isEarning}){
    TextEditingController titleController = TextEditingController();
    TextEditingController amountController = TextEditingController();
    DateTime entryDate = DateTime.now();

    showModalBottomSheet(
        context: context,
        isScrollControlled: true, // Allows the bottom sheet to take full screen height if needed
        builder: (context){
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom, // Adjust padding when keyboard appears
          left: 16.0,
          right: 16.0,
          top: 16.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
                Text(
                  isEarning ? "Add Income" : "Add Expense",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: isEarning ? Colors.green : Colors.red),
                ),
            SizedBox(height: 20,),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                hintText: 'Enter title',
                prefixIcon: Icon(Icons.title),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: isEarning ? Colors.green : Colors.red, width: 2.0),
                ),
              ),
            ),
            SizedBox(height: 16,),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount',
                hintText: 'Enter amount',
                prefixIcon: Icon(Icons.attach_money),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(color: isEarning ? Colors.green : Colors.red, width: 2.0),
                ),
              ),
            ),
            SizedBox(height: 12,),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isEarning ? Colors.green : Colors.red,

                  ),
                  onPressed: (){
                    if(titleController.text.isNotEmpty && amountController.text.isNotEmpty){
                    _addEntry(titleController.text, double.parse(amountController.text), entryDate, isEarning);
                    Navigator.pop(context);
                    }
                  }, child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                                  isEarning ? "Add Income" : "Add Expense", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                                ),
                  )),
            ),
            SizedBox(height: 20,),
          ],
        ),
      );
    });

  }

  void _addEntry(String title, double amount, DateTime date, bool isEarning){

    if(isEarning){
      setState(() {
        _earning.add({
          'title': title,
          'amount': amount,
          'date': date,
        });
      });
    }
    else{
      setState(() {
        _expense.add({
          'title': title,
          'amount': amount,
          'date': date,
        });
      });
    }
    _saveData();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Money Management", style: TextStyle(color: Colors.white)),
        leading: const BackButton(color: Colors.white),
        bottom: TabBar(
          indicatorColor:
              Colors.white, // Color of the indicator below the selected tab
          indicatorWeight: 3.0, // Thickness of the indicator
          labelColor: Colors.white, // Color of the selected tab text
          unselectedLabelColor: Colors.white.withOpacity(
            0.7,
          ), // Color of unselected tab text
          controller: _tabController,
          tabs: [
            Tab(
              icon: Icon(Icons.arrow_upward, color: Colors.white),
              child: Text("Earning", style: TextStyle(color: Colors.white)),
            ),
            Tab(
              icon: Icon(Icons.arrow_downward, color: Colors.white),
              child: Text("Expense", style: TextStyle(color: Colors.white)),
            ),
          ],

        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Row(
            children: [
              _buildSummaryCard(
                title: 'Earning',
                value: totalEarning,
                color: Colors.green,
              ),
              _buildSummaryCard(
                title: 'Expense',
                value: totalExpanse,
                color: Colors.red,
              ),
              _buildSummaryCard(
                title: 'Balance',
                value: balance,
                color: Colors.blue,
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
                controller: _tabController,
                children: [
              _buildList(_earning, Colors.green, true),
              _buildList(_expense, Colors.red, false),
            ]),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFABOptions(context);
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

Widget _buildSummaryCard({
  required String title,
  required double value,
  required Color color,
}) {
  return Expanded(
    child: Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              value.toString(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


Widget _buildList(List<Map<String, dynamic>> items, Color color, bool isEarning){
  return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index){
    return Card(
      child: ListTile(
        leading: CircleAvatar(
 backgroundColor: color.withOpacity(0.2),
          child: Icon(isEarning ? Icons.arrow_upward : Icons.arrow_downward, color: color,),
 ),
        title: Text(items[index]['title']),
        subtitle: Text(DateFormat('dd/MM/yyyy HH:mm').format(items[index]['date'])),
        trailing: Text('${isEarning ? '+' : '-'} ${items[index]['amount'].toString()}', style: TextStyle(color:color, fontSize: 16, fontWeight: FontWeight.bold),),

        ),
      );
  });
}