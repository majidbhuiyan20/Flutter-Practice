import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice/recipe_app/features/home/view/recipe_details_screen.dart';
import 'package:practice/recipe_app/features/home/widgets/recipe_horizontal_card.dart';
import 'package:practice/recipe_app/features/home/widgets/top_chef_horizontal_list.dart';

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
                Row(
                  children: [
                    Text(
                      "Categories",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Text("Sell All", style: TextStyle(color: Colors.green, fontWeight: FontWeight.w700),),
                  ],
                ),
                SizedBox(height: 12),
                DummyRecipeHorizontalList(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      "Top Chefs",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    TopChefHorizontalList(),
                  ],
                ),
                Row(
                  children: [

                  ],
                ),
                Row(
                  children: [
                    Text("Popular Recipe", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),),
                    Spacer(),
                    Text("See All", style: TextStyle(color: Colors.green, fontWeight: FontWeight.w700),),
                  ],
                ),
                SizedBox(height: 16,),


        recipeState.when(
          data: (majidRecipeList) {
            return SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: majidRecipeList.length,
                itemBuilder: (context, index) {
                  final recipe = majidRecipeList[index];

                  return RecipeHorizontalCard(
                    recipe: recipe,
                  );
                },
              ),
            );
          },
          error: (e, _) {
            return SizedBox(
              height: 220,
              child: Center(
                child: Text(e.toString()),
              ),
            );
          },
          loading: () => SizedBox(
            height: 220,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        )



        ],
            ),


          ],
        ),
      ),
    );
  }
}
