import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice/recipe_app/features/home/view/recipe_details_screen.dart';

import '../../common/widgets/custom_app_bar.dart';
import '../../common/widgets/custom_search_bar.dart';
import '../view_model/providers.dart';
import '../widgets/recipe_horizontal_list.dart';

class RecipeHomeScreen extends ConsumerStatefulWidget {
  const RecipeHomeScreen({super.key});

  @override
  ConsumerState<RecipeHomeScreen> createState() => _RecipeHomeScreenState();
}

class _RecipeHomeScreenState extends ConsumerState<RecipeHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final recipeState = ref.watch(recipeProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomSearchBar(),
            SizedBox(height: 16,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Popular Recipes",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                DummyRecipeHorizontalList(),
              ],
            ),
            Expanded(
              child: recipeState.when(data: (data){
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final recipe = data[index];

                    return ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RecipeDetailsScreen(recipeId: recipe.id),
                          ),
                        );
                      },
                      leading: Image.network(recipe.image, width: 50),
                      title: Text(recipe.name),
                    );
                  },
                );

              },
                  error: (error, stack){
                return Center(child: Text(error.toString()));
                  }, loading: ()=> Center(child: CircularProgressIndicator())),
            )

          ],
        ),
      ),
    );
  }
}
