import '../home/model/recipe_model.dart';
import 'api_client.dart';

class RecipeRepository {
  final ApiClient apiClient;

  RecipeRepository(this.apiClient);

  // Fetch all recipes
  Future<List<MajidRecipeRepo>> fetchRecipe() async {
    final response = await apiClient.get("/recipes");
    final data = response.data['recipes'] as List;
    return data.map((e) => MajidRecipeRepo.fromJson(e)).toList();
  }

  // Fetch single recipe details by ID
  Future<MajidRecipeRepo> fetchRecipeDetails(int id) async {
    final response = await apiClient.get("/recipes/$id");
    return MajidRecipeRepo.fromJson(response.data);
  }
}
