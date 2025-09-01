import 'dart:convert';

import 'package:flutter/material.dart';

class DisplayRecipesScreen extends StatefulWidget {
  const DisplayRecipesScreen({super.key});

  @override
  State<DisplayRecipesScreen> createState() => _DisplayRecipesScreenState();
}

class _DisplayRecipesScreenState extends State<DisplayRecipesScreen> {
  final String jsonString = '''
  {
    "recipes": [
      {
        "title": "Pasta Carbonara",
        "description": "Creamy pasta dish with bacon and cheese.",
        "ingredients": ["spaghetti", "bacon", "egg", "cheese"]
      },
      {
        "title": "Caprese Salad",
        "description": "Simple and refreshing salad with tomatoes, mozzarella, and basil.",
        "ingredients": ["tomatoes", "mozzarella", "basil"]
      },
      {
        "title": "Banana Smoothie",
        "description": "Healthy and creamy smoothie with bananas and milk.",
        "ingredients": ["bananas", "milk"]
      },
      {
        "title": "Chicken Stir-Fry",
        "description": "Quick and flavorful stir-fried chicken with vegetables.",
        "ingredients": ["chicken breast", "broccoli", "carrot", "soy sauce"]
      },
      {
        "title": "Grilled Salmon",
        "description": "Delicious grilled salmon with lemon and herbs.",
        "ingredients": ["salmon fillet", "lemon", "olive oil", "dill"]
      },
      {
        "title": "Vegetable Curry",
        "description": "Spicy and aromatic vegetable curry.",
        "ingredients": ["mixed vegetables", "coconut milk", "curry powder"]
      },
      {
        "title": "Berry Parfait",
        "description": "Layered dessert with fresh berries and yogurt.",
        "ingredients": ["berries", "yogurt", "granola"]
      }
    ]
  }
  ''';

  @override
  Widget build(BuildContext context) {
    final List<Recipe> recipes = RecipeService.parseRecipes(jsonString);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Food Recipes',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        leading: BackButton(
          color: Colors.white,
        ),
      ),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          // Assign different colors to cards based on index
          final cardColor = _getCardColor(index);
          return RecipeCard(recipe: recipe, cardColor: cardColor);
        },
      ),
    );
  }
}

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final Color cardColor;

  const RecipeCard({super.key, required this.recipe, required this.cardColor});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardColor, // Use the assigned color for the card background
      elevation: 5,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                recipe.title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 2.0,
                      color: Colors.black.withOpacity(0.3),
                      offset: const Offset(1.0, 1.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                recipe.description,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Ingredients:',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 5),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: recipe.ingredients.map((ingredient) => Chip(
                  label: Text(ingredient,
                      style: TextStyle(color: Colors.orange.shade900)),
                  backgroundColor: Colors.white.withOpacity(0.9),
                )).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// recipe_model.dart
class Recipe {
  final String title;
  final String description;
  final List<String> ingredients;

  Recipe({
    required this.title,
    required this.description,
    required this.ingredients,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
      ingredients: List<String>.from(json['ingredients'] ?? []),
    );
  }
}

class RecipeService {
  static List<Recipe> parseRecipes(String jsonString) {
    try {
      final Map<String, dynamic> data = json.decode(jsonString);
      final List<dynamic> recipesJson = data['recipes'];

      return recipesJson.map((recipeJson) => Recipe.fromJson(recipeJson)).toList();
    } catch (e) {
      print('Error parsing JSON: $e');
      return [];
    }
  }
}

// Helper function to get different colors for cards
Color _getCardColor(int index) {
  final List<Color> colors = [
    Colors.red.shade300,
    Colors.blue.shade300,
    Colors.green.shade300,
    Colors.purple.shade300,
    Colors.teal.shade300,
    Colors.amber.shade300,
    Colors.cyan.shade300,
    Colors.pink.shade300,
  ];
  return colors[index % colors.length]; // Cycle through the colors
}