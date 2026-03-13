import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice/recipe_app/features/home/view/recipe_details_screen.dart';
import 'package:practice/recipe_app/features/home/model/recipe_model.dart';
import 'package:practice/recipe_app/features/home/widgets/recipe_horizontal_card.dart';
import 'package:practice/recipe_app/features/home/widgets/top_chef_horizontal_list.dart';

import '../../common/widgets/custom_app_bar.dart';
import '../../common/widgets/custom_search_bar.dart';
import '../view_model/providers.dart';
import '../widgets/recipe_horizontal_list.dart';

class RecipeHomeScreen extends ConsumerWidget {
  const RecipeHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipeState = ref.watch(recipeProvider);
    final featuredRecipe = recipeState.maybeWhen(
      data: (recipes) => recipes.isNotEmpty ? recipes.first : null,
      orElse: () => null,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      appBar: CustomAppBar(
        backgroundColor: const Color(0xFFF7F7FB),
        elevation: 0,
        title: const _HomeHeaderTitle(),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 18,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.notifications_none_rounded),
              color: const Color(0xFF181725),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomSearchBar(),
            const SizedBox(height: 20),
            _FeaturedRecipeBanner(recipe: featuredRecipe),
            const SizedBox(height: 28),
            const _SectionHeader(
              title: 'Browse by mood',
              subtitle: 'Hand-picked collections for every craving',
              actionLabel: 'See all',
            ),
            const SizedBox(height: 14),
            DummyRecipeHorizontalList(),
            const SizedBox(height: 28),
            const _SectionHeader(
              title: 'Top chefs',
              subtitle: 'Creators people are cooking with this week',
              actionLabel: 'Explore',
            ),
            const SizedBox(height: 14),
            TopChefHorizontalList(),
            const SizedBox(height: 28),
            const _SectionHeader(
              title: 'Popular recipes',
              subtitle: 'Fresh inspiration for lunch and dinner',
              actionLabel: 'More',
            ),
            const SizedBox(height: 14),
            recipeState.when(
              data: (majidRecipeList) {
                return SizedBox(
                  height: 290,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: majidRecipeList.length,
                    itemBuilder: (context, index) {
                      final recipe = majidRecipeList[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) =>
                                      RecipeDetailsScreen(recipeId: recipe.id),
                            ),
                          );
                        },
                        child: RecipeHorizontalCard(recipe: recipe),
                      );
                    },
                  ),
                );
              },
              error: (e, _) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.cloud_off_rounded,
                        size: 42,
                        color: Color(0xFFFF7A5C),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Unable to load recipes right now',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        e.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Color(0xFF7C7C8A)),
                      ),
                    ],
                  ),
                );
              },
              loading:
                  () => const SizedBox(
                    height: 260,
                    child: Center(child: CircularProgressIndicator()),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeHeaderTitle extends StatelessWidget {
  const _HomeHeaderTitle();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Hello, foodie 👋',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF7C7C8A),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 2),
        Text(
          'Find your next favorite recipe',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Color(0xFF181725),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String actionLabel;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF181725),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 13, color: Color(0xFF7C7C8A)),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          actionLabel,
          style: const TextStyle(
            color: Color(0xFF1F8B57),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _FeaturedRecipeBanner extends StatelessWidget {
  final MajidRecipeRepo? recipe;

  const _FeaturedRecipeBanner({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        image:
            recipe == null
                ? null
                : DecorationImage(
                  image: NetworkImage(recipe!.image),
                  fit: BoxFit.cover,
                ),
        gradient:
            recipe == null
                ? const LinearGradient(
                  colors: [Color(0xFF1F8B57), Color(0xFF44B678)],
                )
                : null,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1F8B57).withOpacity(0.18),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(recipe == null ? 0.08 : 0.12),
              Colors.black.withOpacity(recipe == null ? 0.12 : 0.68),
            ],
          ),
        ),
        padding: const EdgeInsets.all(2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Text(
                'Featured recipe',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Spacer(),
            Text(
              recipe?.name ?? 'Fresh flavors for your kitchen',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w700,
                height: 1.15,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              recipe == null
                  ? 'Discover trending meals, seasonal ideas, and elegant dishes that make home cooking feel special.'
                  : '${recipe!.cuisine} • ${recipe!.difficulty} • ${recipe!.rating.toStringAsFixed(1)} rating',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white.withOpacity(0.86),
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _HeroStat(
                  icon: Icons.schedule_rounded,
                  label:
                      recipe == null
                          ? '25+ mins'
                          : '${recipe!.prepTimeMinutes + recipe!.cookTimeMinutes} mins',
                ),
                const SizedBox(width: 10),
                _HeroStat(
                  icon: Icons.local_fire_department_rounded,
                  label:
                      recipe == null
                          ? 'Balanced'
                          : '${recipe!.caloriesPerServing} kcal',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HeroStat({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
