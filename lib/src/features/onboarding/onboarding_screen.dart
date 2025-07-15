import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/navigation/app_router.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  final VoidCallback? onOnboardingComplete;
  
  const OnboardingScreen({
    super.key,
    this.onOnboardingComplete,
  });

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Welcome to White Label POS',
      description: 'Your complete point of sale solution for modern businesses. Manage sales, inventory, and customers all in one place.',
      icon: Icons.store,
      color: Colors.blue,
    ),
    OnboardingPage(
      title: 'Fast & Easy Sales',
      description: 'Process transactions quickly with our intuitive POS interface. Support for barcode scanning and multiple payment methods.',
      icon: Icons.point_of_sale,
      color: Colors.green,
    ),
    OnboardingPage(
      title: 'Inventory Management',
      description: 'Keep track of your stock levels, set up low stock alerts, and manage your product catalog efficiently.',
      icon: Icons.inventory,
      color: Colors.orange,
    ),
    OnboardingPage(
      title: 'Powerful Analytics',
      description: 'Get insights into your business performance with detailed reports and analytics.',
      icon: Icons.analytics,
      color: Colors.purple,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  Future<void> _completeOnboarding() async {
    // Use the proper onboarding provider
    await ref.read(onboardingProvider).completeOnboarding();
    
    if (mounted) {
      // Use callback if provided, otherwise just mark as complete
      widget.onOnboardingComplete?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Semantics(
          label: 'Onboarding screen, page ${_currentPage + 1} of ${_pages.length}',
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Semantics(
                    label: 'Skip onboarding and go to login',
                    button: true,
                    child: TextButton(
                      onPressed: _skipOnboarding,
                      child: Text(
                        'Skip',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              // Page content
              Expanded(
                child: Semantics(
                  label: 'Onboarding content area',
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: _pages.length,
                    itemBuilder: (context, index) {
                      final page = _pages[index];
                      return _OnboardingPageView(
                        page: page,
                        pageNumber: index + 1,
                        totalPages: _pages.length,
                      );
                    },
                  ),
                ),
              ),
              
              // Bottom section with indicators and buttons
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    // Page indicators
                    Semantics(
                      label: 'Page ${_currentPage + 1} of ${_pages.length}',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _pages.length,
                          (index) => Semantics(
                            label: index == _currentPage 
                                ? 'Current page ${index + 1}'
                                : 'Page ${index + 1}',
                            excludeSemantics: true,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: _currentPage == index ? 24 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _currentPage == index
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.primary.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Action buttons
                    Row(
                      children: [
                        // Back button (only show if not on first page)
                        if (_currentPage > 0)
                          Expanded(
                            child: Semantics(
                              label: 'Go to previous page',
                              button: true,
                              child: OutlinedButton(
                                onPressed: () {
                                  _pageController.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                child: Text(
                                  'Back',
                                  style: theme.textTheme.labelLarge,
                                ),
                              ),
                            ),
                          ),
                        
                        if (_currentPage > 0) const SizedBox(width: 16),
                        
                        // Next/Get Started button
                        Expanded(
                          child: Semantics(
                            label: _currentPage == _pages.length - 1 
                                ? 'Complete onboarding and get started'
                                : 'Go to next page',
                            button: true,
                            child: ElevatedButton(
                              onPressed: _nextPage,
                              child: Text(
                                _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class _OnboardingPageView extends StatelessWidget {
  final OnboardingPage page;
  final int pageNumber;
  final int totalPages;

  const _OnboardingPageView({
    required this.page,
    required this.pageNumber,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Semantics(
      label: 'Onboarding page $pageNumber of $totalPages: ${page.title}',
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Semantics(
              label: '${page.title} icon',
              excludeSemantics: true,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: page.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(60),
                ),
                child: Icon(
                  page.icon,
                  size: 60,
                  color: page.color,
                ),
              ),
            ),
            
            const SizedBox(height: 48),
            
            // Title
            Semantics(
              label: 'Page title: ${page.title}',
              header: true,
              child: Text(
                page.title,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Description
            Semantics(
              label: 'Page description: ${page.description}',
              child: Text(
                page.description,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 