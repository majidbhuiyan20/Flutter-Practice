import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/widgets/custom_app_bar.dart';
import '../../common/widgets/custom_search_bar.dart';
import '../view_model/providers.dart';

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
            Expanded(
              child: recipeState.when(data: (data){
                return ListView.builder(itemBuilder: (context, index){
                  final recipe = data[index];
                  return ListTile(
                    leading: Image.network(recipe.image, width: 50,),
                    title: Text(recipe.name),
                  );
                });
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
