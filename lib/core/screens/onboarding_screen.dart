import 'package:flutter/material.dart';
import 'package:furniture_store_application/core/core.dart';
import 'package:furniture_store_application/features/home/home.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // ... (весь код состояния остается без изменений) ...
  final PageController _pageController = PageController();
  final ValueNotifier<int> _currentPageNotifier = ValueNotifier<int>(0);

  static const List<_OnboardingItem> _onboardingItems = [
    _OnboardingItem(
      title: 'Welcome to Furniture Store',
      description: 'Discover the best furniture for your home.',
      imagePath: 'assets/images/onboarding1.png',
    ),
    _OnboardingItem(
      title: 'Quality Products',
      description: 'We offer high-quality furniture at affordable prices.',
      imagePath: 'assets/images/onboarding2.png',
    ),
    _OnboardingItem(
      title: 'Easy Shopping',
      description:
          'Shop from the comfort of your home with our easy-to-use app.',
      imagePath: 'assets/images/onboarding3.png',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _currentPageNotifier.dispose();
    super.dispose();
  }

  void _goToHomeScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => const HomeScreen(),
      ),
    );
  }

  void _onNext() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingItems.length,
                onPageChanged: (index) {
                  _currentPageNotifier.value = index;
                },
                itemBuilder: (context, index) {
                  return _OnboardingPageContent(item: _onboardingItems[index]);
                },
              ),
            ),
            _PageIndicators(
              itemCount: _onboardingItems.length,
              currentPageNotifier: _currentPageNotifier,
            ),
            const SizedBox(height: 24),
            _OnboardingBottomBar(
              itemCount: _onboardingItems.length,
              currentPageNotifier: _currentPageNotifier,
              onNext: _onNext,
              onSkip: _goToHomeScreen,
              onGetStarted: _goToHomeScreen,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// --- ВИДЖЕТЫ ---

class _OnboardingPageContent extends StatelessWidget {
  const _OnboardingPageContent({required this.item});
  final _OnboardingItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(item.imagePath, height: 300),
          const SizedBox(height: 40),
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: context.displayLarge?.copyWith(
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            item.description,
            textAlign: TextAlign.center,
            style: context.bodyLarge,
          ),
        ],
      ),
    );
  }
}

class _PageIndicators extends StatelessWidget {
  // Добавляем const
  const _PageIndicators({
    required this.itemCount,
    required this.currentPageNotifier,
  });
  final int itemCount;
  final ValueNotifier<int> currentPageNotifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: currentPageNotifier,
      builder: (context, currentPage, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(itemCount, (index) {
            final isActive = currentPage == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 8,
              width: isActive ? 24 : 8,
              decoration: BoxDecoration(
                color: isActive
                    ? context.primaryColor
                    : context.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
            );
          }),
        );
      },
    );
  }
}

class _OnboardingBottomBar extends StatelessWidget {
  // Добавляем const
  const _OnboardingBottomBar({
    required this.itemCount,
    required this.currentPageNotifier,
    required this.onNext,
    required this.onSkip,
    required this.onGetStarted,
  });
  final int itemCount;
  final ValueNotifier<int> currentPageNotifier;
  final VoidCallback onNext;
  final VoidCallback onSkip;
  final VoidCallback onGetStarted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ValueListenableBuilder<int>(
        valueListenable: currentPageNotifier,
        builder: (context, currentPage, _) {
          final isLastPage = currentPage.isLastIndex(itemCount);
          return isLastPage
              ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: onGetStarted,
                  child: const Text('Get Started'),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(onPressed: onSkip, child: const Text('Skip')),
                    ElevatedButton(
                      onPressed: onNext,
                      child: const Text('Next'),
                    ),
                  ],
                );
        },
      ),
    );
  }
}

@immutable
class _OnboardingItem {
  const _OnboardingItem({
    required this.title,
    required this.description,
    required this.imagePath,
  });

  final String title;
  final String description;
  final String imagePath;
}
