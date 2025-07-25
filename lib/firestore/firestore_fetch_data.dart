import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final _fireStore = FirebaseFirestore.instance;

class FirestoreFetchData extends StatefulWidget {
  const FirestoreFetchData({super.key});

  @override
  State<FirestoreFetchData> createState() => _FirestoreFetchDataState();
}

class _FirestoreFetchDataState extends State<FirestoreFetchData> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fetch Data from Firestore'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://images.unsplash.com/photo-1528459801416-a9e53bbf4e17?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'), // Replace with your image URL
            fit: BoxFit.cover,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
        stream: _fireStore
        .collection('students')
            .where('userId', isEqualTo: user!.uid)  // Add this filter
            .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final data = snapshot.requireData;
            return ListView.builder(
              itemCount: data.size,
              itemBuilder: (context, index) {
                final document = data.docs[index];
                final name = document['name'] as String?;
                final department = document['department'] as String?;
                final university = document['university'] as String?;
                return Card(
                  color: Colors.white.withOpacity(0.8), // Make card semi-transparent
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(name ?? 'No Name'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(department ?? 'No Department'),
                        Text(university ?? 'No University'),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}