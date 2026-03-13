import 'package:flutter/material.dart';

class TopChefHorizontalList extends StatelessWidget {
  TopChefHorizontalList({super.key});

  final List<Map<String, String>> chefs = [
    {
      'name': 'Gordon Ramsay',
      'image':
          'https://images.unsplash.com/photo-1600891964599-f61ba0e24092?w=200&q=80',
      'recipes': '120',
    },
    {
      'name': 'Nigella Lawson',
      'image':
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200&q=80',
      'recipes': '98',
    },
    {
      'name': 'Massimo Bottura',
      'image':
          'https://images.unsplash.com/photo-1598970434795-0c54fe7c0642?w=200&q=80',
      'recipes': '110',
    },
    {
      'name': 'Alice Waters',
      'image':
          'https://images.unsplash.com/photo-1526738549141-9c0de63a2869?w=200&q=80',
      'recipes': '87',
    },
    {
      'name': 'Jamie Oliver',
      'image':
          'https://images.unsplash.com/photo-1520813792240-56fc4a3765a7?w=200&q=80',
      'recipes': '105',
    },
    {
      'name': 'Thomas Keller',
      'image':
          'https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=200&q=80',
      'recipes': '95',
    },
    {
      'name': 'Rachel Ray',
      'image':
          'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=200&q=80',
      'recipes': '100',
    },
    {
      'name': 'Anthony Bourdain',
      'image':
          'https://images.unsplash.com/photo-1502767089025-6572583495b0?w=200&q=80',
      'recipes': '115',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 188,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: chefs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final chef = chefs[index];

          return Container(
            width: 150,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 24,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.network(
                        chef['image']!,
                        width: 58,
                        height: 58,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 58,
                            height: 58,
                            color: Colors.grey[300],
                            child: const Icon(Icons.person, size: 30),
                          );
                        },
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF7F1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.verified_rounded,
                        size: 16,
                        color: Color(0xFF1F8B57),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  chef['name']!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF181725),
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${chef['recipes']} signature recipes',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF7C7C8A),
                  ),
                ),
                const Spacer(),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFB067), Color(0xFFFF7A5C)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_rounded, color: Colors.white, size: 16),
                      SizedBox(width: 6),
                      Text(
                        'Follow',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
