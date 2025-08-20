import 'package:flutter/material.dart';
import 'package:furniture_store_application/core/app_state.dart';
import 'package:furniture_store_application/features/home/presentation/screens/cart_screen.dart';
import 'package:furniture_store_application/features/home/presentation/screens/categories_screen.dart';
import 'package:furniture_store_application/features/home/presentation/screens/discover_screen.dart';
import 'package:furniture_store_application/features/home/presentation/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late final AnimationController _fadeController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 250),
  )..forward();

  final _pages = const [
    DiscoverScreen(),
    CategoriesScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, animation) {
          final slide =
              Tween<Offset>(begin: const Offset(0.02, 0), end: Offset.zero)
                  .chain(CurveTween(curve: Curves.easeOut))
                  .animate(animation);
          return SlideTransition(
              position: slide,
              child: FadeTransition(opacity: animation, child: child),);
        },
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) {
              if (index == _currentIndex) return;
              setState(() => _currentIndex = index);
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.explore_outlined),
                selectedIcon: Icon(Icons.explore),
                label: 'Discover',
              ),
              NavigationDestination(
                icon: Icon(Icons.category_outlined),
                selectedIcon: Icon(Icons.category),
                label: 'Categories',
              ),
              NavigationDestination(
                icon:
                    _CartBadge(child: Icon(Icons.shopping_cart_outlined)),
                selectedIcon:
                    _CartBadge(child: Icon(Icons.shopping_cart)),
                label: 'Cart',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CartBadge extends StatelessWidget {
  const _CartBadge({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          top: -6,
          right: -6,
          child: SizedBox(
            height: 16,
            child: ValueListenableBuilder<List<String>>(
              valueListenable: AppState.instance.cartProductIds,
              builder: (context, ids, _) {
                if (ids.isEmpty) return const SizedBox.shrink();
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(minWidth: 16),
                  child: Center(
                    child: Text(
                      ids.length.toString(),
                      style: const TextStyle(fontSize: 10, color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
