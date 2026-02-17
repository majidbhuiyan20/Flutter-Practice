import 'package:dio/dio.dart';
import 'package:practice/ostad_flutter/live_test_json/display_recipes_screen.dart';
import 'package:practice/recipe_app/features/home/model/recipe_model.dart';
import 'package:provider/provider.dart' hide Provider, FutureProvider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../network/api_client.dart';
import '../../network/repository.dart';


final dioProvider = Provider<Dio>((ref) => Dio());

final apiClientProvider = Provider<ApiClient>(
      (ref) => ApiClient(ref.read(dioProvider)),
);

final recipeRepositoryProvider = Provider<RecipeRepository>(
      (ref) => RecipeRepository(ref.read(apiClientProvider)),
);

final recipeProvider = FutureProvider<List<MajidRecipeRepo>>((ref) async {
  final repo = ref.read(recipeRepositoryProvider);
  return await repo.fetchRecipe();
});
