import 'package:practice/ostad_flutter/live_test_json/display_recipes_screen.dart';
import 'package:practice/recipe_app/features/network/api_client.dart';

import '../home/model/recipe_model.dart';

class RecipeRepository {
  final ApiClient apiClient;
  RecipeRepository(this.apiClient);

  Future<List<MajidRecipeRepo>> fetchRecipe() async {
    final response = await apiClient.get("/recipes");

    final List recipes = response.data['recipes'];

    return recipes
        .map((recipe) => MajidRecipeRepo.fromJson(recipe))
        .toList();
  }


}