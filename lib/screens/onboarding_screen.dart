import 'package:flutter/material.dart';
import 'package:daily_reset/theme.dart';
import 'package:daily_reset/services/storage_service.dart';
import 'package:daily_reset/components/core/components.dart';
import 'package:go_router/go_router.dart';
import 'package:daily_reset/widgets/program_hero_image.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Track Tiny Habits',
      description:
          'Build lasting change with small, achievable habits that fit into your busy day.',
      imageAsset: 'assets/onboarding/welcome_1.png',
    ),
    OnboardingPage(
      title: 'Log Your Mood Daily',
      description:
          'Check in with yourself each day and see how your habits impact your wellbeing.',
      imageAsset: 'assets/onboarding/welcome_2.png',
    ),
    OnboardingPage(
      title: 'See Your Progress',
      description:
          'Watch your streaks grow and celebrate every small win on your journey.',
      imageAsset: 'assets/onboarding/welcome_3.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) => _buildPage(_pages[index]),
              ),
            ),
            Padding(
              padding: AppSpacing.paddingLg,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => _buildDot(index),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  if (_currentPage == _pages.length - 1)
                    SizedBox(
                      width: double.infinity,
                      child: DRButtonPrimary(
                        label: 'Get Started',
                        isFullWidth: true,
                        onPressed: () => _completeOnboarding(context),
                      ),
                    )
                  else
                    Row(
                      children: [
                        DRButtonGhost(
                          label: 'Skip',
                          onPressed: () => _completeOnboarding(context),
                        ),
                        const Spacer(),
                        DRButtonPrimary(
                          label: 'Next',
                          onPressed: () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Padding(
      padding: AppSpacing.paddingXl,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: ProgramHeroImage(
                imagePath: page.imageAsset,
                aspectRatio: 3 / 4,
                borderRadius: 24,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg), // Reduced from xxl
          Text(
            page.title,
            style: context.textStyles.headlineLarge?.copyWith(fontSize: 28), // Slightly smaller if needed
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            page.description,
            style: context.textStyles.bodyLarge?.withColor(
              Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    final isActive = index == _currentPage;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Future<void> _completeOnboarding(BuildContext context) async {
    final storage = await StorageService.getInstance();
    await storage.saveBool('onboarding_completed', true);
    if (context.mounted) {
      context.go('/home');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final String imageAsset;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.imageAsset,
  });
}
