import 'package:flutter/material.dart';

import '../routes/app_router.dart';
import '../theme/app_colors.dart';
import '../widgets/app_button.dart';
import '../widgets/app_chrome.dart';

class OnboardingSlide {
  final IconData icon;
  final String title;
  final String description;
  final String note;

  const OnboardingSlide({
    required this.icon,
    required this.title,
    required this.description,
    required this.note,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController(viewportFraction: 0.88);
  int _currentIndex = 0;

  final List<OnboardingSlide> _slides = const [
    OnboardingSlide(
      icon: Icons.swap_horiz_rounded,
      title: 'Trade what is idle into something worth keeping.',
      description:
          'Turn spare items into local exchanges with calmer discovery and less clutter.',
      note: 'Thoughtful swaps, not impulse shopping.',
    ),
    OnboardingSlide(
      icon: Icons.auto_awesome_rounded,
      title: 'Discover curated listings that feel close and relevant.',
      description:
          'Browse by mood, category, or location with a cleaner feed that stays easy to scan.',
      note: 'Minimal cards, richer detail, faster browsing.',
    ),
    OnboardingSlide(
      icon: Icons.forum_rounded,
      title: 'Move from interest to agreement with direct conversation.',
      description:
          'Chat with owners, negotiate exchanges, and arrange pickup in one place.',
      note: 'Simple messaging with a clear next step.',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentIndex < _slides.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
      return;
    }
    Navigator.pushReplacementNamed(context, RouteNames.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackdrop(
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const AppLogo(size: 46, radius: 16),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Swapiify',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Playfair Display',
                          ),
                        ),
                        Text(
                          'Intentional local exchange',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(
                        context,
                        RouteNames.login,
                      ),
                      child: const Text(
                        'Skip',
                        style: TextStyle(color: AppColors.mutedForeground),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                // AppSectionHeading(
                //   eyebrow: 'A cleaner way to swap',
                //   title: slide.title,
                //   subtitle: slide.description,
                // ),
                // const SizedBox(height: 24),
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    onPageChanged: (index) =>
                        setState(() => _currentIndex = index),
                    itemCount: _slides.length,
                    itemBuilder: (context, index) {
                      final item = _slides[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Container(
                            //   width: 72,
                            //   height: 72,
                            //   decoration: BoxDecoration(
                            //     gradient: const LinearGradient(
                            //       colors: [
                            //         AppColors.coralLight,
                            //         AppColors.coral,
                            //       ],
                            //       begin: Alignment.topLeft,
                            //       end: Alignment.bottomRight,
                            //     ),
                            //     borderRadius: BorderRadius.circular(24),
                            //   ),
                            //   child: Icon(
                            //     item.icon,
                            //     size: 32,
                            //     color: AppColors.cream,
                            //   ),
                            // ),
                            // const SizedBox(height: 24),
                            Expanded(
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  final compact = constraints.maxHeight < 260;
                                  final titleSize = compact ? 20.0 : 24.0;
                                  final bodySize = compact ? 13.0 : 14.0;
                                  final noteSize = compact ? 12.0 : 13.0;

                                  return Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.plumDark,
                                      borderRadius: BorderRadius.circular(28),
                                    ),
                                    padding: EdgeInsets.all(compact ? 18 : 24),
                                    child: SingleChildScrollView(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            '0${index + 1}',
                                            style: const TextStyle(
                                              color: AppColors.coralLight,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 1.4,
                                            ),
                                          ),
                                          SizedBox(height: compact ? 10 : 14),
                                          Text(
                                            item.title,
                                            maxLines: compact ? 3 : 4,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: AppColors.cream,
                                              fontSize: titleSize,
                                              height: 1.15,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Playfair Display',
                                            ),
                                          ),
                                          SizedBox(height: compact ? 8 : 12),
                                          Text(
                                            item.description,
                                            maxLines: compact ? 3 : 4,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: AppColors.cream.withValues(
                                                alpha: 0.8,
                                              ),
                                              fontSize: bodySize,
                                              height: 1.45,
                                            ),
                                          ),
                                          SizedBox(height: compact ? 12 : 16),
                                          Container(
                                            padding: EdgeInsets.all(
                                              compact ? 12 : 14,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.cream.withValues(
                                                alpha: 0.08,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              border: Border.all(
                                                color: AppColors.cream
                                                    .withValues(alpha: 0.08),
                                              ),
                                            ),
                                            child: Text(
                                              item.note,
                                              maxLines: compact ? 2 : 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: AppColors.cream
                                                    .withValues(alpha: 0.88),
                                                fontSize: noteSize,
                                                height: 1.4,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    ...List.generate(_slides.length, (index) {
                      final active = index == _currentIndex;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOut,
                        margin: const EdgeInsets.only(right: 8),
                        width: active ? 28 : 9,
                        height: 9,
                        decoration: BoxDecoration(
                          color: active ? AppColors.plumDark : AppColors.border,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      );
                    }),
                    const Spacer(),
                    Text(
                      '${_currentIndex + 1}/${_slides.length}',
                      style: const TextStyle(
                        color: AppColors.mutedForeground,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: 'Explore preview',
                        onPressed: () => Navigator.pushReplacementNamed(
                          context,
                          RouteNames.home,
                        ),
                        variant: AppButtonVariant.outline,
                        size: AppButtonSize.xl,
                        fullWidth: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppButton(
                        label: _currentIndex == _slides.length - 1
                            ? 'Get started'
                            : 'Continue',
                        icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                        onPressed: _next,
                        variant: AppButtonVariant.coral,
                        size: AppButtonSize.xl,
                        fullWidth: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
