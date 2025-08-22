import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class Feature {
  final String title;
  final IconData icon;
  final String route;  // add route path

  Feature({
    required this.title,
    required this.icon,
    required this.route,
  });
}

class FeatureCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String route;

  const FeatureCard({
    super.key,
    required this.title,
    required this.icon,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          context.push(route);  // Navigate on tap
        },
      ),
    );
  }
}

//Create a Riverpod Provider for the Feature List
final featureListProvider = StateProvider<List<Feature>>((ref) => [
  Feature(title: 'Test Card', icon: Icons.leaderboard_rounded, route: '/test'),
  Feature(title: 'Notification', icon: Icons.notifications, route: '/notification'),
  Feature(title: 'API Call', icon: Icons.cloud_download, route: '/apiUI'),
  Feature(title: 'Firestore', icon: Icons.storage, route: '/firestore'),
  Feature(title: 'Local Storage', icon: Icons.storage, route: '/localStorage'),
  Feature(title: 'Ostad Work', icon: Icons.home_work, route: '/ostadHome'),
  Feature(title: 'Basic Calculator', icon: Icons.calculate, route: '/calculator'),
  Feature(title: 'Water Tracker', icon: Icons.water_drop, route: '/waterTracker'),
  Feature(title: 'Money Management', icon: Icons.attach_money, route: '/moneyManagement'),
  Feature(title: 'Todo App Basic', icon: Icons.list_alt, route: '/toDo'),
  Feature(title: 'CRUD App', icon: Icons.edit_document, route: '/crudApp'),

]);