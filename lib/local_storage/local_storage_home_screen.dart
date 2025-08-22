import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../home_page/feature_card.dart';

class LocalStorageHomeScreen extends ConsumerWidget {
  const LocalStorageHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localStorageItems = ref.watch(localStorageCardProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Local Storage', style: TextStyle(color: Colors.white),), backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),),

      body:  ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: localStorageItems.length,
        itemBuilder: (context, index) {
          final feature = localStorageItems[index];
          return Column(
            children: [
              FeatureCard(title: feature.title, icon: feature.icon, route: feature.route,),
              const SizedBox(height: 12),
            ],
          );
        },
      ),
    );
  }
}


final localStorageCardProvider = Provider<List<Feature>>((ref) => [
  Feature(
    title: 'Shared Preferences',
    icon: Icons.settings_applications,
    route: '/sharedPreferences',
  ),
  Feature(
      title: 'Hive',
      icon: Icons.storage,
      route: '/hive'
  ),
  Feature(
      title: 'SqfLite',
      icon: Icons.data_usage,
      route: '/studentDatabasePage'
  ),

]);
