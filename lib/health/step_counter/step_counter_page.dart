import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class StepCounterPage extends StatefulWidget {
  const StepCounterPage({super.key});

  @override
  State<StepCounterPage> createState() => _StepCounterPageState();
}

class _StepCounterPageState extends State<StepCounterPage> with WidgetsBindingObserver {
  // Step count variables
  int _todaySteps = 0;
  int _totalSteps = 0;
  int _dailyGoal = 10000;
  int _baselineSteps = 0;

  late Stream<StepCount> _stepCountStream;
  bool _isCounting = false;
  String _status = 'Initializing...';

  // For storing step history
  List<Map<String, dynamic>> _stepHistory = [];

  // UI State
  int _selectedIndex = 0; // 0: Today, 1: History

  late SharedPreferences _prefs;
  DateTime _lastResetDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initialize();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _saveTodaySteps();
    } else if (state == AppLifecycleState.resumed) {
      _checkDateChange();
    }
  }

  Future<void> _initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _loadSavedData();
    _checkPermissionsAndInitialize();
    _checkDateChange();
  }

  void _loadSavedData() {
    // Load baseline steps
    _baselineSteps = _prefs.getInt('baselineSteps') ?? 0;

    // Load today's steps
    _todaySteps = _prefs.getInt('todaySteps') ?? 0;

    // Load daily goal
    _dailyGoal = _prefs.getInt('dailyGoal') ?? 10000;

    // Load last date
    String? lastDateStr = _prefs.getString('lastDate');
    if (lastDateStr != null) {
      _lastResetDate = DateTime.parse(lastDateStr);
    }

    // Load step history
    String? historyStr = _prefs.getString('stepHistory');
    if (historyStr != null) {
      _stepHistory = List<Map<String, dynamic>>.from(json.decode(historyStr));
    } else {
      // Initialize with sample data for demonstration
      _stepHistory = [
        {'date': '2024-01-15', 'steps': 8432, 'goal': 10000},
        {'date': '2024-01-14', 'steps': 12543, 'goal': 10000},
        {'date': '2024-01-13', 'steps': 5678, 'goal': 10000},
        {'date': '2024-01-12', 'steps': 9876, 'goal': 10000},
        {'date': '2024-01-11', 'steps': 7345, 'goal': 10000},
      ];
    }
  }

  Future<void> _saveData() async {
    await _prefs.setInt('baselineSteps', _baselineSteps);
    await _prefs.setInt('todaySteps', _todaySteps);
    await _prefs.setInt('dailyGoal', _dailyGoal);
    await _prefs.setString('lastDate', _lastResetDate.toIso8601String());
    await _prefs.setString('stepHistory', json.encode(_stepHistory));
  }

  void _checkDateChange() {
    DateTime now = DateTime.now();
    if (!_isSameDay(_lastResetDate, now)) {
      _saveTodaySteps();
      _resetForNewDay();
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void _saveTodaySteps() {
    // Save today's steps to history before resetting
    if (_todaySteps > 0) {
      String todayDate = '${_lastResetDate.year}-${_lastResetDate.month.toString().padLeft(2, '0')}-${_lastResetDate.day.toString().padLeft(2, '0')}';

      // Check if we already have an entry for today
      int existingIndex = _stepHistory.indexWhere((item) => item['date'] == todayDate);

      if (existingIndex >= 0) {
        // Update existing entry
        _stepHistory[existingIndex]['steps'] = _todaySteps;
        _stepHistory[existingIndex]['goal'] = _dailyGoal;
      } else {
        // Add new entry
        _stepHistory.insert(0, {
          'date': todayDate,
          'steps': _todaySteps,
          'goal': _dailyGoal,
        });
      }

      // Keep only last 30 days
      if (_stepHistory.length > 30) {
        _stepHistory = _stepHistory.sublist(0, 30);
      }

      _saveData();
    }
  }

  void _resetForNewDay() {
    setState(() {
      _baselineSteps = _totalSteps; // Set new baseline to current total
      _todaySteps = 0;
      _lastResetDate = DateTime.now();
      _status = 'New day started!';
    });
    _saveData();
  }

  // Check and request permissions
  Future<void> _checkPermissionsAndInitialize() async {
    // Request activity recognition permission for Android
    PermissionStatus status = await Permission.activityRecognition.request();

    if (status.isGranted) {
      _initializePedometer();
    } else {
      setState(() {
        _status = 'Permission denied. Cannot count steps.';
      });
    }
  }

  // Initialize pedometer
  void _initializePedometer() {
    try {
      _stepCountStream = Pedometer.stepCountStream;
      _stepCountStream.listen(_onStepCount,
          onError: _onError, onDone: _onDone);

      setState(() {
        _isCounting = true;
        _status = 'Counting steps...';
      });
    } catch (error) {
      setState(() {
        _status = 'Error initializing pedometer. Using alternative method...';
        _isCounting = false;
      });
    }
  }

  // Handle step count updates
  void _onStepCount(StepCount event) {
    setState(() {
      _totalSteps = event.steps;

      // If baseline is 0, set it to current total
      if (_baselineSteps == 0) {
        _baselineSteps = _totalSteps;
      }

      // Calculate today's steps (total - baseline)
      _todaySteps = _totalSteps - _baselineSteps;

      // Ensure we don't show negative numbers
      if (_todaySteps < 0) {
        _todaySteps = 0;
        _baselineSteps = _totalSteps;
      }

      _status = 'Counting steps...';
    });
    _saveData();
  }

  // Handle errors
  void _onError(error) {
    setState(() {
      _status = 'Step counter paused. Keep walking!';
    });
  }

  // Handle stream completion
  void _onDone() {
    setState(() {
      _status = 'Step counting stopped';
      _isCounting = false;
    });
  }

  // Reset today's steps only
  void _resetTodaySteps() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset Today\'s Steps'),
          content: const Text('Are you sure you want to reset today\'s step count?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _baselineSteps = _totalSteps;
                  _todaySteps = 0;
                });
                _saveData();
                Navigator.pop(context);
              },
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }

  // Reset all history
  void _resetAllHistory() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset All Data'),
          content: const Text('Are you sure you want to reset all step history?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _stepHistory.clear();
                  _todaySteps = 0;
                  _baselineSteps = _totalSteps;
                });
                _saveData();
                Navigator.pop(context);
              },
              child: const Text('Reset All'),
            ),
          ],
        );
      },
    );
  }

  // Set daily goal
  void _showSetGoalDialog() {
    final TextEditingController goalController = TextEditingController(
      text: _dailyGoal.toString(),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Set Daily Goal'),
          content: TextField(
            controller: goalController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Enter steps goal',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _dailyGoal = int.tryParse(goalController.text) ?? 10000;
                });
                _saveData();
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Calculate progress percentage
  double get _progress {
    if (_dailyGoal <= 0) return 0;
    return (_todaySteps / _dailyGoal).clamp(0.0, 1.0);
  }

  // Get today's date in readable format
  String get _todayDate {
    DateTime now = DateTime.now();
    return '${now.day}/${now.month}/${now.year}';
  }

  // Build Today View
  Widget _buildTodayView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Step count display
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Today\'s Steps',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            _todayDate,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '$_todaySteps',
                      style: const TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Progress bar
                    LinearProgressIndicator(
                      value: _progress,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.green,
                      ),
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Goal: $_dailyGoal steps',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _isCounting ? Colors.green.shade50 : Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _status,
                        style: TextStyle(
                          color: _isCounting ? Colors.green.shade700 : Colors.orange.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Control buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _resetTodaySteps,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset Today'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: _showSetGoalDialog,
                  icon: const Icon(Icons.flag),
                  label: const Text('Set Goal'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Info card
            Card(
              color: Colors.blue.shade50,
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Keep walking! Your steps are being counted automatically.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build History View
  Widget _buildHistoryView() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Step History',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_sweep),
                onPressed: _resetAllHistory,
                tooltip: 'Clear History',
              ),
            ],
          ),
        ),
        Expanded(
          child: _stepHistory.isEmpty
              ? const Center(
            child: Text('No step history yet. Start walking!'),
          )
              : ListView.builder(
            itemCount: _stepHistory.length,
            itemBuilder: (context, index) {
              final entry = _stepHistory[index];
              double progress = (entry['steps'] / entry['goal']).clamp(0.0, 1.0);

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: ListTile(
                  title: Text(
                    entry['date'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          progress >= 1.0 ? Colors.green : Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${entry['steps']} / ${entry['goal']} steps',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  trailing: entry['steps'] >= entry['goal']
                      ? const Icon(Icons.emoji_events, color: Colors.amber)
                      : Text(
                    '${(progress * 100).toInt()}%',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  isThreeLine: true,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Step Counter'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_selectedIndex == 0)
            IconButton(
              icon: const Icon(Icons.history),
              onPressed: () {
                setState(() {
                  _selectedIndex = 1;
                });
              },
              tooltip: 'View History',
            )
          else
            IconButton(
              icon: const Icon(Icons.today),
              onPressed: () {
                setState(() {
                  _selectedIndex = 0;
                });
              },
              tooltip: 'View Today',
            ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade100, Colors.white],
          ),
        ),
        child: _selectedIndex == 0 ? _buildTodayView() : _buildHistoryView(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_walk),
            label: 'Today',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _saveTodaySteps();
    super.dispose();
  }
}