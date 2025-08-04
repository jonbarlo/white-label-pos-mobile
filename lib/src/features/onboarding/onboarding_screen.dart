import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/navigation/app_router.dart';
import '../../core/localization/app_localizations.dart';

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

  List<OnboardingPage> _getPages(AppLocalizations? l10n) {
    return [
      OnboardingPage(
        title: l10n?.onboardingPage1Title ?? 'Welcome to Mobile POS',
        description: l10n?.onboardingPage1Description ?? 'Manage your restaurant operations efficiently with our comprehensive POS system',
        icon: Icons.store,
        color: Colors.blue,
      ),
      OnboardingPage(
        title: l10n?.onboardingPage2Title ?? 'Easy Order Management',
        description: l10n?.onboardingPage2Description ?? 'Take orders quickly and manage tables with our intuitive interface',
        icon: Icons.point_of_sale,
        color: Colors.green,
      ),
      OnboardingPage(
        title: l10n?.onboardingPage3Title ?? 'Real-time Kitchen Display',
        description: l10n?.onboardingPage3Description ?? 'Keep track of orders in real-time with our kitchen display system',
        icon: Icons.inventory,
        color: Colors.orange,
      ),
      OnboardingPage(
        title: l10n?.onboardingPage4Title ?? 'Comprehensive Reports',
        description: l10n?.onboardingPage4Description ?? 'Generate detailed reports and analytics to optimize your business',
        icon: Icons.analytics,
        color: Colors.purple,
      ),
    ];
  }

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
    final l10n = AppLocalizations.of(context)!;
    final pages = _getPages(l10n);
    if (_currentPage < pages.length - 1) {
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
    final l10n = AppLocalizations.of(context)!;
    final pages = _getPages(l10n);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Semantics(
          label: '${l10n.onboardingScreen}, ${l10n.page} ${_currentPage + 1} ${l10n.ofText} ${pages.length}',
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Semantics(
                    label: l10n.skipOnboardingAndGoToLogin,
                    child: TextButton(
                      onPressed: _skipOnboarding,
                      child: Text(l10n.skip),
                    ),
                  ),
                ),
              ),
              
              // Page content
              Expanded(
                child: Semantics(
                  label: l10n.onboardingContentArea,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: pages.length,
                    itemBuilder: (context, index) {
                      final page = pages[index];
                      return _buildOnboardingPage(page, theme);
                    },
                  ),
                ),
              ),
              
              // Navigation buttons
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back button
                    if (_currentPage > 0)
                      Semantics(
                        label: l10n.goToPreviousPage,
                        child: TextButton(
                          onPressed: () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: Text(l10n.back),
                        ),
                      )
                    else
                      const SizedBox(width: 80),
                    
                    // Page indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        pages.length,
                        (index) => Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == index
                                ? theme.colorScheme.primary
                                : theme.colorScheme.outline.withOpacity(0.3),
                          ),
                        ),
                      ),
                    ),
                    
                    // Next/Get Started button
                    Semantics(
                      label: _currentPage == pages.length - 1 
                          ? l10n.completeOnboardingAndGetStarted
                          : l10n.goToNextPage,
                      child: ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          _currentPage == pages.length - 1 
                              ? l10n.getStarted 
                              : l10n.next,
                        ),
                      ),
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

  Widget _buildOnboardingPage(OnboardingPage page, ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: page.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              page.icon,
              size: 60,
              color: page.color,
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Title
          Text(
            page.title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),
          
          // Description
          Text(
            page.description,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
} 
