import 'package:flutter/material.dart';

class TopChefHorizontalList extends StatelessWidget {
  TopChefHorizontalList({super.key});

  final List<Map<String, String>> chefs = [
    {
      "name": "Gordon Ramsay",
      "image":
      "https://images.unsplash.com/photo-1600891964599-f61ba0e24092?w=200&q=80",
      "recipes": "120"
    },
    {
      "name": "Nigella Lawson",
      "image":
      "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200&q=80",
      "recipes": "98"
    },
    {
      "name": "Massimo Bottura",
      "image":
      "https://images.unsplash.com/photo-1598970434795-0c54fe7c0642?w=200&q=80",
      "recipes": "110"
    },
    {
      "name": "Alice Waters",
      "image":
      "https://images.unsplash.com/photo-1526738549141-9c0de63a2869?w=200&q=80",
      "recipes": "87"
    },
    {
      "name": "Jamie Oliver",
      "image":
      "https://images.unsplash.com/photo-1520813792240-56fc4a3765a7?w=200&q=80",
      "recipes": "105"
    },
    {
      "name": "Thomas Keller",
      "image":
      "https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=200&q=80",
      "recipes": "95"
    },
    {
      "name": "Rachel Ray",
      "image":
      "https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=200&q=80",
      "recipes": "100"
    },
    {
      "name": "Anthony Bourdain",
      "image":
      "https://images.unsplash.com/photo-1502767089025-6572583495b0?w=200&q=80",
      "recipes": "115"
    },
    {
      "name": "Heston Blumenthal",
      "image":
      "https://images.unsplash.com/photo-1514996937319-344454492b37?w=200&q=80",
      "recipes": "89"
    },
    {
      "name": "Dominique Crenn",
      "image":
      "https://images.unsplash.com/photo-1544005313-72672a499ef5?w=200&q=80",
      "recipes": "78"
    },
    {
      "name": "Bobby Flay",
      "image":
      "https://images.unsplash.com/photo-1508214751196-bcfd4ca60f91?w=200&q=80",
      "recipes": "92"
    },
    {
      "name": "Cat Cora",
      "image":
      "https://images.unsplash.com/photo-1520813792240-0564a7212441?w=200&q=80",
      "recipes": "83"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: chefs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final chef = chefs[index];

          return Column(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      chef["image"]!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey[300],
                          child: const Icon(Icons.person, size: 40),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "${chef["recipes"]} Recipes",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              SizedBox(
                width: 80,
                child: Text(
                  chef["name"]!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
