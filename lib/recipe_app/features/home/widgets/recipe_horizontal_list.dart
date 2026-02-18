import 'package:flutter/material.dart';

class DummyRecipeHorizontalList extends StatelessWidget {
  DummyRecipeHorizontalList({super.key});

  final List<Map<String, String>> recipes = [
    {
      "name": "Salad",
      "image":
      "https://images.unsplash.com/photo-1550304943-4f24f54ddde9?w=200&q=80"
    },
    {
      "name": "Pizza",
      "image":
      "https://hips.hearstapps.com/hmg-prod/images/classic-cheese-pizza-recipe-2-64429a0cb408b.jpg?crop=0.6666666666666667xw:1xh;center,top&resize=1200:*"
    },
    {
      "name": "Burger",
      "image":
      "https://images.unsplash.com/photo-1550547660-d9450f859349?w=200&q=80"
    },
    {
      "name": "Pasta",
      "image":
      "https://media.istockphoto.com/id/155433174/photo/bolognese-pens.jpg?s=612x612&w=0&k=20&c=A_TBqOAzcOkKbeVv8qSDs0bukfAedhkA458JEFolo_M="
    },
    {
      "name": "Sandwich",
      "image":
      "https://images.unsplash.com/photo-1528735602780-2552fd46c7af?w=200&q=80"
    },
    {
      "name": "Fried Rice",
      "image":
      "https://www.kitchensanctuary.com/wp-content/uploads/2020/04/Chicken-Fried-Rice-square-FS-.jpg"
    },
    {
      "name": "Steak",
      "image":
      "https://images.unsplash.com/photo-1600891964599-f61ba0e24092?w=200&q=80"
    },
    {
      "name": "Sushi",
      "image":
      "https://images.unsplash.com/photo-1553621042-f6e147245754?w=200&q=80"
    },
    {
      "name": "Tacos",
      "image":
      "https://images.unsplash.com/photo-1552332386-f8dd00dc2f85?w=200&q=80"
    },
    {
      "name": "Ice Cream",
      "image":
      "https://images.unsplash.com/photo-1497034825429-c343d7c6a68f?w=200&q=80"
    },
  ];



  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: recipes.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final recipe = recipes[index];

          return Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  recipe["image"]!,
                  height: 68,
                  width: 68,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.network(
                      "https://via.placeholder.com/68",
                      height: 68,
                      width: 68,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),

              const SizedBox(height: 6),
              Text(
                recipe["name"]!,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
