import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'feature_card.dart';
class HomePageScreen extends ConsumerWidget {
  const HomePageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = FirebaseAuth.instance;
    final featureList = ref.watch(featureListProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white), // Set back button color to white
        title: const Text('Practice Section', style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search, color: Colors.white,)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert, color: Colors.white,)),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white,),
            onPressed: () async {
              try {
                await auth.signOut();
              
              } catch (e) {
                // Handle sign-out errors, e.g., display a SnackBar
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error signing out: $e')));
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: featureList.length,
        itemBuilder: (context, index) {
          final feature = featureList[index];
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

