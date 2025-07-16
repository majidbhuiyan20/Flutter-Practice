import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'feature_card.dart';
class HomePageScreen extends ConsumerWidget {
  const HomePageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featureList = ref.watch(featureListProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Practice Section', style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
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

