import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'feature_card.dart';

class HomePageScreen extends ConsumerWidget {
  const HomePageScreen({super.key});

  // Helper to setup FCM
  Future<void> setupFCM() async {
    final messaging = FirebaseMessaging.instance;

    // Request permission
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Small delay to ensure APNs token is ready
      await Future.delayed(const Duration(seconds: 2));

      // Get FCM token
      String? token = await messaging.getToken();
      debugPrint("✅ FCM Token: $token");

      // Listen for token refresh
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        debugPrint("🔄 FCM Token Refreshed: $newToken");
      });
    } else {
      debugPrint("❌ Notification permission denied");
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = FirebaseAuth.instance;
    final featureList = ref.watch(featureListProvider);

    // Request FCM token after first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setupFCM();
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Practice Section',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: Colors.white),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert, color: Colors.white),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              try {
                await auth.signOut();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error signing out: $e')),
                );
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
              FeatureCard(
                title: feature.title,
                icon: feature.icon,
                route: feature.route,
              ),
              const SizedBox(height: 12),
            ],
          );
        },
      ),
    );
  }
}
