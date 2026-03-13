import 'package:flutter/material.dart';

class DummyRecipeHorizontalList extends StatelessWidget {
  DummyRecipeHorizontalList({super.key});

  final List<Map<String, String>> recipes = [
    {
      "name": "Healthy",
      "image":
          "https://images.unsplash.com/photo-1550304943-4f24f54ddde9?w=200&q=80",
    },
    {
      "name": "Cheesy",
      "image":
          "https://hips.hearstapps.com/hmg-prod/images/classic-cheese-pizza-recipe-2-64429a0cb408b.jpg?crop=0.6666666666666667xw:1xh;center,top&resize=1200:*",
    },
    {
      "name": "Grill",
      "image":
          "https://images.unsplash.com/photo-1550547660-d9450f859349?w=200&q=80",
    },
    {
      "name": "Pasta",
      "image":
          "https://media.istockphoto.com/id/155433174/photo/bolognese-pens.jpg?s=612x612&w=0&k=20&c=A_TBqOAzcOkKbeVv8qSDs0bukfAedhkA458JEFolo_M=",
    },
    {
      "name": "Brunch",
      "image":
          "https://images.unsplash.com/photo-1528735602780-2552fd46c7af?w=200&q=80",
    },
    {
      "name": "Asian",
      "image":
          "https://www.kitchensanctuary.com/wp-content/uploads/2020/04/Chicken-Fried-Rice-square-FS-.jpg",
    },
    {
      "name": "Steak",
      "image":
          "https://images.unsplash.com/photo-1600891964599-f61ba0e24092?w=200&q=80",
    },
    {
      "name": "Sushi",
      "image":
          "https://images.unsplash.com/photo-1553621042-f6e147245754?w=200&q=80",
    },
    {
      "name": "Mexican",
      "image":
          "https://images.unsplash.com/photo-1552332386-f8dd00dc2f85?w=200&q=80",
    },
    {
      "name": "Dessert",
      "image":
          "https://images.unsplash.com/photo-1497034825429-c343d7c6a68f?w=200&q=80",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: recipes.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          final isSelected = index == 0;

          return Container(
            width: 92,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF1F8B57) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.network(
                    recipe['image']!,
                    height: 56,
                    width: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 56,
                        width: 56,
                        color: Colors.grey[200],
                        child: const Icon(Icons.fastfood_rounded),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  recipe['name']!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : const Color(0xFF181725),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
