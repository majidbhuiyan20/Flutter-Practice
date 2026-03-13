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
      backgroundColor: const Color(0xFFF7F7FB),
      appBar: CustomAppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Text(
          'Recipe details',
          style: TextStyle(
            color: Colors.grey[900],
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.92),
              borderRadius: BorderRadius.circular(16),
            ),
            child: IconButton(
              icon: const Icon(Icons.favorite_border_rounded),
              color: const Color(0xFF181725),
              onPressed: () {},
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: recipeState.when(
        loading:
            () => const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
              ),
            ),
        error:
            (err, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
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
          return Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: RecipeHeaderImage(
                      imageUrl: recipe.image,
                      title: recipe.name,
                      subtitle: _buildRecipeSummary(recipe),
                      rating: recipe.rating,
                      totalTime:
                          recipe.prepTimeMinutes + recipe.cookTimeMinutes,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Transform.translate(
                      offset: const Offset(0, -28),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFFF7F7FB),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(32),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: [
                                  _buildInfoChip(
                                    label: recipe.cuisine,
                                    color: const Color(0xFFFFF1E8),
                                    textColor: const Color(0xFFFF7A5C),
                                    icon: Icons.public_rounded,
                                  ),
                                  _buildInfoChip(
                                    label: recipe.difficulty,
                                    color: _getDifficultyColor(
                                      recipe.difficulty,
                                    ).withOpacity(0.12),
                                    textColor: _getDifficultyColor(
                                      recipe.difficulty,
                                    ),
                                    icon: Icons.bolt_rounded,
                                  ),
                                  _buildInfoChip(
                                    label: '${recipe.reviewCount} reviews',
                                    color: const Color(0xFFEEF7F1),
                                    textColor: const Color(0xFF1F8B57),
                                    icon: Icons.chat_bubble_outline_rounded,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              Text(
                                recipe.name,
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF181725),
                                  height: 1.15,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'A beautifully balanced ${recipe.cuisine.toLowerCase()} dish with ${recipe.ingredients.length} ingredients and simple step-by-step guidance for a confident cooking session.',
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF6C6C80),
                                  height: 1.6,
                                ),
                              ),
                              const SizedBox(height: 22),
                              Container(
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF1F8B57),
                                      Color(0xFF44B678),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(26),
                                ),
                                child: Row(
                                  children: [
                                    const Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Cooking vibe',
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12,
                                            ),
                                          ),
                                          SizedBox(height: 6),
                                          Text(
                                            'Fresh, flavorful, and worth sharing',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              height: 1.3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Container(
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.18),
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      child: const Icon(
                                        Icons.restaurant_menu_rounded,
                                        color: Colors.white,
                                        size: 28,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                              RecipeMetaInfo(
                                prepTime: recipe.prepTimeMinutes,
                                cookTime: recipe.cookTimeMinutes,
                                servings: recipe.servings,
                              ),
                              const SizedBox(height: 24),
                              RecipeRatingCard(
                                rating: recipe.rating,
                                reviewCount: recipe.reviewCount,
                              ),
                              if (recipe.mealType.isNotEmpty) ...[
                                const SizedBox(height: 24),
                                _buildChipSection(
                                  title: 'Best served for',
                                  subtitle:
                                      'Great moments to enjoy this recipe',
                                  items: recipe.mealType,
                                  color: const Color(0xFFF2F3FF),
                                  textColor: const Color(0xFF5C63D8),
                                ),
                              ],
                              if (recipe.tags.isNotEmpty) ...[
                                const SizedBox(height: 24),
                                _buildChipSection(
                                  title: 'Why you will love it',
                                  subtitle: 'Quick highlights from the kitchen',
                                  items: recipe.tags.take(6).toList(),
                                  color: const Color(0xFFFFF3E8),
                                  textColor: const Color(0xFFFF7A5C),
                                ),
                              ],
                              const SizedBox(height: 24),
                              RecipeIngredientsCard(
                                ingredients: recipe.ingredients,
                              ),
                              const SizedBox(height: 24),
                              RecipeInstructionsCard(
                                instructions: recipe.instructions,
                              ),
                              const SizedBox(height: 24),
                              RecipeNutritionCard(
                                caloriesPerServing: recipe.caloriesPerServing,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                left: 20,
                right: 20,
                bottom: 24,
                child: SafeArea(
                  top: false,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF181725),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      elevation: 12,
                      shadowColor: Colors.black.withOpacity(0.18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text(
                      'Start cooking',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _buildRecipeSummary(MajidRecipeRepo recipe) {
    final mealType =
        recipe.mealType.isNotEmpty
            ? recipe.mealType.join(' • ')
            : 'Anytime meal';
    return '${recipe.cuisine} • $mealType • ${recipe.servings} servings';
  }

  Widget _buildInfoChip({
    required String label,
    required Color color,
    required Color textColor,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(color: textColor, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _buildChipSection({
    required String title,
    required String subtitle,
    required List<String> items,
    required Color color,
    required Color textColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF181725),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 13, color: Color(0xFF7C7C8A)),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children:
              items
                  .map(
                    (item) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Text(
                        item,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  )
                  .toList(),
        ),
      ],
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
