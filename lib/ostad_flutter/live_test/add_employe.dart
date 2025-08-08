import 'package:flutter/material.dart';

class Employee {
  final String name;
  final int age;
  final double salary;
  Employee({required this.name, required this.age, required this.salary});
}

class AddEmployee extends StatefulWidget {
  const AddEmployee({super.key});

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _salaryController = TextEditingController();
  final List<Employee> _employees = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        elevation: 0,
        title: const Text(
          "Add Employee",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      style: TextStyle(color: Colors.grey[700]),
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: 'Name',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        prefixIcon: Icon(Icons.person, color: Colors.blue),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0), // Use blue color
                            borderSide: BorderSide.none),

                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      style: TextStyle(color: Colors.grey[700]),
                      controller: _ageController,
                      decoration: InputDecoration(
                        hintText: 'Age',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        prefixIcon: Icon(Icons.cake, color: Colors.blue),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide.none),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an age';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid age';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      style: TextStyle(color: Colors.grey[700]),
                      controller: _salaryController,
                      decoration: InputDecoration(
                        hintText: 'Salary',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        prefixIcon: Icon(Icons.attach_money, color: Colors.blue),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide.none),

                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a salary';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid salary';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0))),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _employees.add(Employee(
                              name: _nameController.text,
                              age: int.parse(_ageController.text),
                              salary: double.parse(_salaryController.text),
                            ));
                            _nameController.clear();
                            _ageController.clear();
                            _salaryController.clear();
                          });
                        }
                      },
                      child: const Text('Add Employee', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                )),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _employees.length,
              itemBuilder: (context, index) {
                final employee = _employees[index];
                return Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                        backgroundColor: Colors.blue, child: Text(employee.name[0], style: const TextStyle(color: Colors.white))),
                    title: Text(employee.name, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[700])),
                    subtitle: Text('Age: ${employee.age}, Salary: \$${employee.salary.toStringAsFixed(2)}', style: TextStyle(color: Colors.grey[600])),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
