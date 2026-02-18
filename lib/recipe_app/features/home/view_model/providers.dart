import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../network/api_client.dart';
import '../../network/repository.dart';
import '../model/recipe_model.dart';

// ------------------- Dio Provider -------------------
final dioProvider = Provider<Dio>((ref) => Dio()); /// This is Global dependency Container of Riverpod State Management

// ------------------- ApiClient Provider -------------------
final apiClientProvider = Provider<ApiClient>(
      (ref) => ApiClient(ref.read(dioProvider)),
);

// ------------------- Repository Provider ------------------
final recipeRepositoryProvider = Provider<RecipeRepository>(
      (ref) => RecipeRepository(ref.read(apiClientProvider)),
);

// ------------------- Recipe List Provider -----------------
final recipeProvider = FutureProvider<List<MajidRecipeRepo>>((ref) async {
  final repo = ref.read(recipeRepositoryProvider);
  return await repo.fetchRecipe();
});

// ------------------- Recipe Details Provider ---------------

final recipeDetailsProvider =
FutureProvider.family<MajidRecipeRepo, int>((ref, id) async {
  final repo = ref.read(recipeRepositoryProvider);
  return await repo.fetchRecipeDetails(id);
});
