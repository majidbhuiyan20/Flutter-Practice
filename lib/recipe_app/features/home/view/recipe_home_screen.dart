import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:practice/recipe_app/features/home/view/recipe_details_screen.dart';
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


                Container(
                  height: 220,
                  width: double.infinity,
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [

                        // 🔵 Background Image
                        Positioned.fill(
                          child: Image.network(
                            "https://images.immediate.co.uk/production/volatile/sites/30/2020/08/chorizo-mozarella-gnocchi-bake-cropped-9ab73a3.jpg?quality=90&resize=700,636",
                            fit: BoxFit.cover,
                          ),
                        ),

                        // 🔵 Dark Gradient Overlay (Bottom readability)
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

                        // 🔵 Top Left - Review Section
                        Positioned(
                          top: 12,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.star,
                                    color: Colors.amber, size: 16),
                                SizedBox(width: 4),
                                Text(
                                  "4.5",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // 🔵 Top Right - Favourite Icon
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.favorite_border,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        // 🔵 Bottom Content
                        Positioned(
                          bottom: 12,
                          left: 12,
                          right: 12,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [

                              // Title
                              Text(
                                "Mozzarella Gnocchi Bake",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              SizedBox(height: 6),

                              // Time & Difficulty
                              Row(
                                children: [
                                  Icon(Icons.access_time,
                                      color: Colors.white70, size: 16),
                                  SizedBox(width: 4),
                                  Text(
                                    "30 min",
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                  SizedBox(width: 12),
                                  Icon(Icons.local_fire_department,
                                      color: Colors.white70, size: 16),
                                  SizedBox(width: 4),
                                  Text(
                                    "Easy",
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )


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
