import 'package:flutter/material.dart';

class MoneyManagement extends StatefulWidget {
  const MoneyManagement({super.key});

  @override
  State<MoneyManagement> createState() => _MoneyManagementState();
}

class _MoneyManagementState extends State<MoneyManagement>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _showFABOptions(BuildContext context){
      showModalBottomSheet(context: context, builder: (context){
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: (){}, child: Text("Add Income", style: TextStyle(color: Colors.white),)),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: (){}, child: Text("Add Expense", style: TextStyle(color: Colors.white),)),
                ),
              ],
          ),
        );
      });
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
                value: 25000,
                color: Colors.green,
              ),
              _buildSummaryCard(
                title: 'Expense',
                value: 10000,
                color: Colors.red,
              ),
              _buildSummaryCard(
                title: 'Balance',
                value: 15000,
                color: Colors.blue,
              ),
            ],
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
