import 'package:flutter/material.dart';
import 'package:furniture_store_application/core/app_state.dart';
import 'package:furniture_store_application/features/home/domain/entities/entities.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({required this.product, super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Hero(
            tag: 'product_${product.id}',
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.asset(product.imagePath, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Text(
                  'High-quality materials and modern design to elevate your home.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: SizedBox(
            height: 48,
            child: FilledButton.icon(
              onPressed: () {
                AppState.instance.addToCart(product.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${product.name} added to cart'),
                    duration: const Duration(milliseconds: 900),
                  ),
                );
              },
              icon: const Icon(Icons.add_shopping_cart_rounded),
              label: const Text('Add to Cart'),
            ),
          ),
        ),
      ),
    );
  }
}
