import 'package:flutter/material.dart';
import 'package:furniture_store_application/core/app_state.dart';
import 'package:furniture_store_application/features/home/domain/entities/entities.dart';
import 'package:furniture_store_application/features/home/presentation/screens/product_detail_screen.dart';
import 'package:furniture_store_application/features/home/presentation/widgets/animated_route.dart';
import 'package:furniture_store_application/features/home/presentation/widgets/product_card.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  static final List<Product> products = [
    const Product(
      id: '1',
      name: 'Modern Sofa',
      price: 499.99,
      imagePath: 'assets/images/3.png',
    ),
    const Product(
      id: '2',
      name: 'Queen Bed',
      price: 799,
      imagePath: 'assets/images/queen_bed.png',
    ),
    const Product(
      id: '3',
      name: 'Dining Table',
      price: 699.50,
      imagePath: 'assets/images/dining_table.png',
    ),
    const Product(
      id: '4',
      name: 'Coffee Table',
      price: 199.99,
      imagePath: 'assets/images/coffee_table.png',
    ),
    const Product(
      id: '5',
      name: 'TV Cabinet',
      price: 299.99,
      imagePath: 'assets/images/tv_cabinet.png',
    ),
    const Product(
      id: '6',
      name: 'Wardrobe',
      price: 899.99,
      imagePath: 'assets/images/wardrobe.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = MediaQuery.of(context).size.width > 600 ? 3 : 2;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: const Text('Discover'),
          floating: true,
          snap: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(120),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'documentation/images/banner.png',
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () async {
                final result = await showSearch<Product?>(
                  context: context,
                  delegate: _ProductSearchDelegate(products),
                );
                if (result != null && context.mounted) {
                  await Navigator.of(context).push(createFadeSlideRoute<void>(
                    ProductDetailScreen(product: result),
                  ),);
                }
              },
            ),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 3 / 4,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final product = products[index];
                return Stack(
                  children: [
                    ProductCard(
                      product: product,
                      onTap: () {
                        Navigator.of(context).push(createFadeSlideRoute<void>(
                          ProductDetailScreen(product: product),
                        ),);
                      },
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: ValueListenableBuilder<Set<String>>(
                        valueListenable: AppState.instance.favoriteIds,
                        builder: (context, favs, _) {
                          final selected = favs.contains(product.id);
                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: () =>
                                  AppState.instance.toggleFavorite(product.id),
                              child: Padding(
                                padding: const EdgeInsets.all(6),
                                child: Icon(
                                  selected
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: selected
                                      ? Colors.redAccent
                                      : Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      right: 8,
                      bottom: 8,
                      child: FilledButton.tonalIcon(
                        onPressed: () {
                          AppState.instance.addToCart(product.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.name} added to cart'),
                              duration: const Duration(milliseconds: 800),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add'),
                      ),
                    ),
                  ],
                );
              },
              childCount: products.length,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProductSearchDelegate extends SearchDelegate<Product?> {
  _ProductSearchDelegate(this._all);
  final List<Product> _all;

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) => _buildList(context);

  @override
  Widget buildSuggestions(BuildContext context) => _buildList(context);

  Widget _buildList(BuildContext context) {
    final lower = query.toLowerCase();
    final results =
        _all.where((p) => p.name.toLowerCase().contains(lower)).toList();
    if (results.isEmpty) {
      return const Center(child: Text('No results'));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final p = results[index];
        return ListTile(
          leading: Image.asset(p.imagePath,
              width: 48, height: 48, fit: BoxFit.cover,),
          title: Text(p.name),
          subtitle: Text('\$${p.price.toStringAsFixed(2)}'),
          onTap: () => close(context, p),
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemCount: results.length,
    );
  }
}
