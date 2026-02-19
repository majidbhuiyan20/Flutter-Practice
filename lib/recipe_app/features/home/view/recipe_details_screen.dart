import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice/recipe_app/features/common/widgets/custom_app_bar.dart';
import 'package:practice/recipe_app/features/home/model/recipe_model.dart';

import '../view_model/providers.dart';
import '../widgets/recipe_header_image.dart';
import '../widgets/recipe_ingradient_card.dart';
import '../widgets/recipe_instruction_card.dart';
import '../widgets/recipe_meta_info.dart';
import '../widgets/recipe_nutration_card.dart';
import '../widgets/recipe_rating_card.dart';

class RecipeDetailsScreen extends ConsumerWidget {
  final int recipeId;

  const RecipeDetailsScreen({super.key, required this.recipeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipeState = ref.watch(recipeDetailsProvider(recipeId));

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: CustomAppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Recipe Details',
          style: TextStyle(
            color: Colors.grey[800],
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: recipeState.when(
        loading: () => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
          ),
        ),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red[300],
              ),
              const SizedBox(height: 16),
              Text(
                'Oops! Something went wrong',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                err.toString(),
                style: TextStyle(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        data: (recipe) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: RecipeHeaderImage(imageUrl: recipe.image),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 80), // Space for overlapping header

                    // Recipe Title Section
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recipe.name,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  recipe.cuisine,
                                  style: const TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: _getDifficultyColor(recipe.difficulty)
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  recipe.difficulty,
                                  style: TextStyle(
                                    color: _getDifficultyColor(recipe.difficulty),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Meta Information
                    RecipeMetaInfo(
                      prepTime: recipe.prepTimeMinutes,
                      cookTime: recipe.cookTimeMinutes,
                      servings: recipe.servings,
                    ),

                    const SizedBox(height: 24),

                    // Rating Card
                    RecipeRatingCard(
                      rating: recipe.rating,
                      reviewCount: recipe.reviewCount,
                    ),

                    const SizedBox(height: 24),

                    // Ingredients Card
                    RecipeIngredientsCard(
                      ingredients: recipe.ingredients,
                    ),

                    const SizedBox(height: 24),

                    // Instructions Card
                    RecipeInstructionsCard(
                      instructions: recipe.instructions,
                    ),

                    const SizedBox(height: 24),

                    // Nutrition Card
                    RecipeNutritionCard(
                      caloriesPerServing: recipe.caloriesPerServing,
                    ),

                    const SizedBox(height: 20),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}