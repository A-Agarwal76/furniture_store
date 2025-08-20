import 'package:flutter/material.dart';
import 'package:furniture_store_application/core/app_state.dart';
import 'package:furniture_store_application/features/home/presentation/screens/discover_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<String>>(
      valueListenable: AppState.instance.cartProductIds,
      builder: (context, ids, _) {
        if (ids.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 72,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 12),
                const Text('Your cart is empty'),
              ],
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: ids.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final id = ids[index];
            final product = DiscoverScreen.products.firstWhere(
              (p) => p.id == id,
              orElse: () => DiscoverScreen.products.first,
            );
            return Dismissible(
              key: ValueKey('cart_${id}_$index'),
              background: Container(color: Colors.redAccent),
              onDismissed: (_) => AppState.instance.removeFromCartAt(index),
              child: ListTile(
                leading: Image.asset(
                  product.imagePath,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                ),
                title: Text(product.name),
                subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
              ),
            );
          },
        );
      },
    );
  }
}
