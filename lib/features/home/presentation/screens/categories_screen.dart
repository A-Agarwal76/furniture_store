import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const categories = [
      'Living Room',
      'Bedroom',
      'Dining',
      'Office',
      'Outdoor',
    ];
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: categories.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        return TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
          tween: Tween(begin: 0, end: 1),
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, (1 - value) * 12),
              child: Opacity(opacity: value, child: child),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  _categoryImage(categories[index]),
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(categories[index]),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ),
        );
      },
    );
  }
}

String _categoryImage(String category) {
  switch (category) {
    case 'Living Room':
      return 'assets/images/3.png';
    case 'Bedroom':
      return 'assets/images/queen_bed.png';
    case 'Dining':
      return 'assets/images/dining_table.png';
    case 'Office':
      return 'assets/images/coffee_table.png';
    default:
      return 'assets/images/wardrobe.png';
  }
}
