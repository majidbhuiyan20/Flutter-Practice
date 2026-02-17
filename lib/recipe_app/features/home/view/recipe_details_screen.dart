import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice/recipe_app/features/common/widgets/custom_app_bar.dart';
import 'package:practice/recipe_app/features/home/model/recipe_model.dart';

import '../view_model/providers.dart';

class RecipeDetailsScreen extends ConsumerWidget {
  final int recipeId;

  const RecipeDetailsScreen({super.key, required this.recipeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipeState = ref.watch(recipeDetailsProvider(recipeId));

    return Scaffold(
      appBar: CustomAppBar(),
      body: recipeState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text(err.toString())),
        data: (recipe) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(recipe.image, width: double.infinity),
                const SizedBox(height: 16),
                Text(
                  recipe.name,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text("Ingredients:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                ...recipe.ingredients.map((e) => Text("• $e")),
                const SizedBox(height: 16),
                Text("Instructions:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                ...recipe.instructions.map((e) => Text("• $e")),
                const SizedBox(height: 16),
                Text("Prep Time: ${recipe.prepTimeMinutes} mins"),
                Text("Cook Time: ${recipe.cookTimeMinutes} mins"),
                Text("Servings: ${recipe.servings}"),
                Text("Difficulty: ${recipe.difficulty}"),
                Text("Cuisine: ${recipe.cuisine}"),
                Text("Calories per Serving: ${recipe.caloriesPerServing}"),
                Text("Rating: ${recipe.rating} (${recipe.reviewCount} reviews)"),
              ],
            ),
          );
        },
      ),
    );
  }
}
