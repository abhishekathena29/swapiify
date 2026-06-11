import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/mock_data.dart';
import '../models/item.dart';
import '../providers/items_provider.dart';
import '../routes/app_router.dart';
import '../theme/app_colors.dart';
import '../widgets/app_button.dart';
import '../widgets/app_chrome.dart';
import '../widgets/app_icons.dart';
import '../widgets/app_input.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = context.read<ItemsProvider>();

    return AppScaffold(
      currentRoute: RouteNames.home,
      body: StreamBuilder<List<Item>>(
        stream: items.itemsStream(),
        builder: (context, snapshot) {
          final list = snapshot.data ?? const <Item>[];
          final isLoading =
              snapshot.connectionState == ConnectionState.waiting;
          final heroItems = list.take(5).toList();

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 130),
            children: [
              const _Header(),
              const SizedBox(height: 18),
              if (heroItems.isNotEmpty) ...[
                _HeroCarousel(items: heroItems),
                const SizedBox(height: 18),
              ],
              const _CategorySection(),
              const SizedBox(height: 18),
              const _HowItWorksSection(),
              const SizedBox(height: 18),
              _RecentSection(items: list, isLoading: isLoading),
              const SizedBox(height: 18),
              const _Callout(),
            ],
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      child: Column(
        children: [
          Row(
            children: [
              const AppAvatar(name: 'Swapiify', inverse: true),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'For today',
                      style: TextStyle(
                        color: AppColors.mutedForeground,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Find something beautiful nearby.',
                      style: TextStyle(
                        fontSize: 20,
                        height: 1.2,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Playfair Display',
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.highlight,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.notifications_none_rounded,
                  color: AppColors.plumDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AppInput(
            hintText: 'Search for cameras, books, bags...',
            prefixIcon: const Icon(Icons.search_rounded, size: 20),
            onSubmitted: (_) =>
                Navigator.pushNamed(context, RouteNames.browse),
          ),
        ],
      ),
    );
  }
}

class _HeroCarousel extends StatefulWidget {
  final List<Item> items;

  const _HeroCarousel({required this.items});

  @override
  State<_HeroCarousel> createState() => _HeroCarouselState();
}

class _HeroCarouselState extends State<_HeroCarousel> {
  final PageController _controller = PageController(viewportFraction: 0.9);
  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void didUpdateWidget(_HeroCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items.length != widget.items.length) {
      if (_index >= widget.items.length) _index = 0;
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    if (widget.items.length <= 1) return;
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_controller.hasClients) return;
      final next = (_index + 1) % widget.items.length;
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 360),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.items;
    return AppPanel(
      color: AppColors.plumDark,
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'FRESH PICKS',
                        style: TextStyle(
                          color: AppColors.coralLight,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.4,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Thoughtful finds, updated daily.',
                        style: TextStyle(
                          color: AppColors.cream,
                          fontSize: 28,
                          height: 1.1,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Playfair Display',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'A softer browsing experience with fewer distractions and stronger item detail.',
                        style: TextStyle(
                          color: AppColors.cream.withValues(alpha: 0.76),
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${_index + 1}/${items.length}',
                  style: TextStyle(
                    color: AppColors.cream.withValues(alpha: 0.72),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 300,
            child: PageView.builder(
              controller: _controller,
              onPageChanged: (value) => setState(() => _index = value),
              itemCount: items.length,
              itemBuilder: (context, itemIndex) {
                final item = items[itemIndex];
                final image = item.images.isNotEmpty ? item.images.first : '';
                return Padding(
                  padding: const EdgeInsets.only(left: 20, right: 8),
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: AppColors.cream,
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 7,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.highlight,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: const Text(
                                    'Fresh listing',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.plumDark,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  item.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    height: 1.12,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Playfair Display',
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Expanded(
                                  child: Text(
                                    item.description.isEmpty
                                        ? '${item.category} • ${item.location}'
                                        : item.description,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 4,
                                    style: const TextStyle(
                                      color: AppColors.mutedForeground,
                                      height: 1.45,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                AppButton(
                                  label: 'View details',
                                  onPressed: () => Navigator.pushNamed(
                                    context,
                                    '${RouteNames.product}/${item.id}',
                                  ),
                                  variant: AppButtonVariant.coral,
                                  fullWidth: true,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 130,
                          height: double.infinity,
                          child: ProductImage(image: image),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(items.length, (dotIndex) {
              final active = dotIndex == _index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: active ? 28 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: active
                      ? AppColors.coralLight
                      : AppColors.cream.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(999),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  const _CategorySection();

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      child: Column(
        children: [
          AppSectionHeading(
            eyebrow: 'Browse by category',
            title: 'Start from a mood, not a maze.',
            subtitle:
                'Quick paths into the kinds of items people actually exchange.',
            trailing: TextButton(
              onPressed: () => Navigator.pushNamed(context, RouteNames.browse),
              child: const Text('Browse all'),
            ),
          ),
          const SizedBox(height: 18),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.95,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return InkWell(
                onTap: () => Navigator.pushNamed(context, RouteNames.browse),
                borderRadius: BorderRadius.circular(22),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: index.isEven ? AppColors.cream : AppColors.highlight,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Icon(
                          appIcon(category.icon),
                          color: AppColors.plumDark,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        category.name,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _HowItWorksSection extends StatelessWidget {
  const _HowItWorksSection();

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSectionHeading(
            eyebrow: 'Simple flow',
            title: 'Post, match, chat, swap.',
            subtitle:
                'Everything is designed to reduce friction without losing trust.',
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 138,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: howItWorks.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final step = howItWorks[index];
                return Container(
                  width: 126,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cream,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '0${step.step}',
                        style: const TextStyle(
                          color: AppColors.coralDark,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppColors.plumDark,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          appIcon(step.icon),
                          color: AppColors.cream,
                          size: 20,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        step.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentSection extends StatelessWidget {
  final List<Item> items;
  final bool isLoading;

  const _RecentSection({required this.items, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      child: Column(
        children: [
          AppSectionHeading(
            eyebrow: 'Latest listings',
            title: 'Fresh swaps with just enough information.',
            subtitle:
                'Fast visual scanning, then deeper detail when you need it.',
            trailing: TextButton(
              onPressed: () => Navigator.pushNamed(context, RouteNames.browse),
              child: const Text('See all'),
            ),
          ),
          const SizedBox(height: 18),
          ProductGridState(
            isLoading: isLoading,
            hasError: false,
            grid: items.isEmpty
                ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: AppColors.highlight,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Text(
                      'No listings yet. Be the first to add an item to swap.',
                      style: TextStyle(
                        color: AppColors.mutedForeground,
                        height: 1.45,
                      ),
                    ),
                  )
                : ItemCardGrid(items: items.take(6).toList()),
          ),
        ],
      ),
    );
  }
}

class _Callout extends StatelessWidget {
  const _Callout();

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      color: AppColors.highlight,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Have something worth trading?',
                  style: TextStyle(
                    fontSize: 24,
                    height: 1.15,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Playfair Display',
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'List it with a calmer, cleaner posting flow and reach nearby swappers quickly.',
                  style: TextStyle(
                    color: AppColors.mutedForeground,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 16),
                AppButton(
                  label: 'Add an item',
                  icon: const Icon(Icons.add_rounded, size: 18),
                  onPressed: () => Navigator.pushNamed(context, RouteNames.add),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.plumDark,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              color: AppColors.cream,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }
}
