import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:practice/rest_api/complex_json/model/user_model.dart';
class ComplexApi extends StatefulWidget {
  const ComplexApi({super.key});

  @override
  State<ComplexApi> createState() => _ComplexApiState();
}

class _ComplexApiState extends State<ComplexApi> {
  List<UserModel> _users = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  final int _pageSize = 5;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchUsers();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && _hasMore && !_isLoading) {
        _fetchUsers();
      }
    });
  }

  Future<void> _fetchUsers() async {
    if (_isLoading || !_hasMore) return;
    setState(() => _isLoading = true);

    try {
      final response = await http.get(
        Uri.parse("https://jsonplaceholder.typicode.com/users?_page=$_currentPage&_limit=$_pageSize"),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        final List<UserModel> fetchedUsers = jsonData.map((json) => UserModel.fromJson(json)).toList();
        setState(() {
          _users.addAll(fetchedUsers);
          _currentPage++;
          _hasMore = fetchedUsers.length == _pageSize;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Optionally, show an error message to the user
      // For example, using a SnackBar or a Dialog
      debugPrint('Network error: $e');
    }
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    setState(() {
      _users = [];
      _currentPage = 1;
      _hasMore = true;
    });
    await _fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Data'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: _users.isEmpty && _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _users.isEmpty && !_isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.info_outline, size: 48, color: Colors.grey),
                        const SizedBox(height: 16),
                        const Text('No users found.', style: TextStyle(fontSize: 18)),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _refreshData,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
              controller: _scrollController,
              itemCount: _users.length + (_hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _users.length) {
                  return _isLoading
                      ? const Center(child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ))
                      : const SizedBox.shrink();
                }
                final user = _users[index];
                return _buildUserCard(user);
              },
            ),
        ),
    );
  }

  Widget _buildUserCard(UserModel user) {
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.name ?? 'No Name',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.email, user.email ?? 'No Email'),
            _buildInfoRow(Icons.phone, user.phone ?? 'No Phone'),
            _buildInfoRow(Icons.location_city, user.address?.city ?? 'No City'),
            _buildInfoRow(Icons.public, 'Lat: ${user.address?.geo?.lat ?? 'N/A'}, Lng: ${user.address?.geo?.lng ?? 'N/A'}'),
            if (user.company != null) ...[
              const SizedBox(height: 8),
              const Divider(),
              Text(
                'Company Info',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              _buildInfoRow(Icons.business, user.company!.name ?? 'No Company'),
              _buildInfoRow(Icons.business, user.company!.catchPhrase ?? 'No Catchphrase'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
