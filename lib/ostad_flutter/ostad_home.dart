import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice/home_page/feature_card.dart';

class OstadHome extends ConsumerWidget {
  const OstadHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ostadWorkList = ref.watch(OstadListProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Ostad Home', style: TextStyle(color: Colors.white),), backgroundColor: Colors.blue,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white,),
        onPressed: () {
          Navigator.pop(context);
        },
      ),),

      body:  ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: ostadWorkList.length,
        itemBuilder: (context, index) {
          final feature = ostadWorkList[index];
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
