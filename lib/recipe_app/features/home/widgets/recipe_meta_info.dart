// features/home/widgets/recipe_meta_info.dart
import 'package:flutter/material.dart';

class RecipeMetaInfo extends StatelessWidget {
  final int prepTime;
  final int cookTime;
  final int servings;

  const RecipeMetaInfo({
    super.key,
    required this.prepTime,
    required this.cookTime,
    required this.servings,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildInfoItem(
            icon: Icons.timer,
            label: 'Prep Time',
            value: '$prepTime min',
            color: Colors.blue,
          ),
          Container(
            height: 40,
            width: 1,
            color: Colors.grey.withOpacity(0.3),
          ),
          _buildInfoItem(
            icon: Icons.timer_outlined,
            label: 'Cook Time',
            value: '$cookTime min',
            color: Colors.orange,
          ),
          Container(
            height: 40,
            width: 1,
            color: Colors.grey.withOpacity(0.3),
          ),
          _buildInfoItem(
            icon: Icons.people,
            label: 'Servings',
            value: servings.toString(),
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}