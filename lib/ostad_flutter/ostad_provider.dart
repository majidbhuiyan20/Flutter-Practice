import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice/home_page/feature_card.dart';

// Create a Riverpod Provider for the Ostad Feature List
final OstadListProvider = StateProvider<List<Feature>>((ref) => [
  Feature(
    title: 'Greeting App',
    icon: Icons.waving_hand,
    route: '/grettingApp',
  ),
  Feature(
    title: 'Live Test', 
    icon: Icons.quiz, 
    route: '/addEmployee'
  ),
  // Add more ostad features here
]);
