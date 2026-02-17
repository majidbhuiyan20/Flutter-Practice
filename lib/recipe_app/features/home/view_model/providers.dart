import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../network/api_client.dart';
import '../../network/repository.dart';
import '../model/recipe_model.dart';

// ------------------- Dio Provider -------------------
final dioProvider = Provider<Dio>((ref) => Dio());

// ------------------- ApiClient Provider -------------------
final apiClientProvider = Provider<ApiClient>(
      (ref) => ApiClient(ref.read(dioProvider)),
);

// ------------------- Repository Provider -------------------
final recipeRepositoryProvider = Provider<RecipeRepository>(
      (ref) => RecipeRepository(ref.read(apiClientProvider)),
);

// ------------------- Recipe List Provider -------------------
final recipeProvider = FutureProvider<List<MajidRecipeRepo>>((ref) async {
  final repo = ref.read(recipeRepositoryProvider);
  return await repo.fetchRecipe(); // returns List<MajidRecipeRepo>
});

// ------------------- Recipe Details Provider -------------------
// Use .family to pass recipeId dynamically
final recipeDetailsProvider =
FutureProvider.family<MajidRecipeRepo, int>((ref, id) async {
  final repo = ref.read(recipeRepositoryProvider);
  return await repo.fetchRecipeDetails(id); // returns a single MajidRecipeRepo
});
