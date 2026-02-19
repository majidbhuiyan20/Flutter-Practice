import 'package:flutter/material.dart';

import '../model/recipe_model.dart';

class RecipeHorizontalCard extends StatelessWidget {
  final MajidRecipeRepo recipe;

  const RecipeHorizontalCard({
    super.key,
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [

            /// 🔵 Background Image
            Positioned.fill(
              child: Image.network(
                recipe.image,
                fit: BoxFit.cover,
              ),
            ),

            /// 🔵 Gradient
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            /// ⭐ Rating
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star,
                        color: Colors.amber, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      recipe.rating.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// ❤️ Favourite Icon
            const Positioned(
              top: 10,
              right: 10,
              child: Icon(Icons.favorite_border,
                  color: Colors.white),
            ),

            /// 🔽 Bottom Info
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          color: Colors.white70,
                          size: 14),
                      const SizedBox(width: 4),
                      Text(
                        "${recipe.prepTimeMinutes} min",
                        style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        recipe.difficulty,
                        style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
