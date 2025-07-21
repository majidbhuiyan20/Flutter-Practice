import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice/firebase/ui/auth/login_screen.dart';

import 'feature_card.dart';
class HomePageScreen extends ConsumerWidget {
  const HomePageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _auth = FirebaseAuth.instance;
    final featureList = ref.watch(featureListProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Practice Section', style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              try {
                await _auth.signOut();
                // Navigate to the login screen
                // Navigator.pushReplacement(context,
                //     MaterialPageRoute(builder: (context) => const LoginScreen()));
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

