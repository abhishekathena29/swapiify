import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/item.dart';
import '../providers/favorites_provider.dart';
import '../providers/items_provider.dart';
import '../routes/app_router.dart';
import '../theme/app_colors.dart';
import '../widgets/app_badge.dart';
import '../widgets/app_button.dart';
import '../widgets/app_chrome.dart';
import '../widgets/app_input.dart';
import '../widgets/bottom_nav.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  String _activeCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>();
    final itemsProvider = context.read<ItemsProvider>();

    return Scaffold(
      body: AppBackdrop(
        child: Stack(
          children: [
            StreamBuilder<List<Item>>(
              stream: itemsProvider.itemsStream(),
              builder: (context, snapshot) {
                final items = snapshot.data ?? const <Item>[];
                final categories = _buildCategories(items);
                final filtered = _activeCategory == 'All'
                    ? items
                    : items
                          .where((item) => item.category == _activeCategory)
                          .toList();

                return ListView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
                  children: [
                    _Header(
                      categories: categories,
                      activeCategory: _activeCategory,
                      onCategoryTap: (value) =>
                          setState(() => _activeCategory = value),
                    ),
                    const SizedBox(height: 18),
                    AppPanel(
                      child: _BrowseGrid(
                        favorites: favorites,
                        items: filtered,
                        isLoading:
                            snapshot.connectionState == ConnectionState.waiting,
                        hasError: snapshot.hasError,
                      ),
                    ),
                  ],
                );
              },
            ),
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: BottomNav(currentRoute: RouteNames.browse),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _buildCategories(List<Item> items) {
    final unique = <String>{};
    for (final item in items) {
      final category = item.category.trim();
      if (category.isNotEmpty) {
        unique.add(category);
      }
    }
    final sorted = unique.toList()..sort();
    return ['All', ...sorted];
  }
}

class _Header extends StatelessWidget {
  final List<String> categories;
  final String activeCategory;
  final ValueChanged<String> onCategoryTap;

  const _Header({
    required this.categories,
    required this.activeCategory,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      child: Column(
        children: [
          AppSectionHeading(
            eyebrow: 'Browse',
            title: 'A calmer marketplace for local swaps.',
            subtitle:
                'Filter by category and move through listings without visual overload.',
            trailing: AppButton(
              icon: const Icon(Icons.tune_rounded, size: 18),
              onPressed: () {},
              variant: AppButtonVariant.outline,
              size: AppButtonSize.icon,
            ),
          ),
          const SizedBox(height: 18),
          const AppInput(
            hintText: 'Search items, styles, categories...',
            prefixIcon: Icon(Icons.search_rounded),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = categories[index];
                return AppBadge(
                  label: category,
                  active: activeCategory == category,
                  onTap: () => onCategoryTap(category),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BrowseGrid extends StatelessWidget {
  final FavoritesProvider favorites;
  final List<Item> items;
  final bool isLoading;
  final bool hasError;

  const _BrowseGrid({
    required this.favorites,
    required this.items,
    required this.isLoading,
    required this.hasError,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(36),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (hasError) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Text('Unable to load items right now.'),
      );
    }
    if (items.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.highlight,
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Text(
          'No items match this filter yet. Try another category or add the first one.',
          style: TextStyle(color: AppColors.mutedForeground, height: 1.45),
        ),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Text(
              '${items.length} items',
              style: const TextStyle(
                color: AppColors.mutedForeground,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            const Text(
              'Newest first',
              style: TextStyle(
                color: AppColors.mutedForeground,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.7,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final image = item.images.isNotEmpty ? item.images.first : '';
            final isFavorite = favorites.isFavorite(item.id);
            return InkWell(
              onTap: () => Navigator.pushNamed(
                context,
                '${RouteNames.product}/${item.id}',
              ),
              borderRadius: BorderRadius.circular(24),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(24),
                              ),
                              child: _ItemImage(image: image),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: InkWell(
                              onTap: () => favorites.toggle(item.id),
                              borderRadius: BorderRadius.circular(999),
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: AppColors.card.withValues(alpha: 0.92),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isFavorite
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_border_rounded,
                                  size: 18,
                                  color: isFavorite
                                      ? AppColors.coralDark
                                      : AppColors.mutedForeground,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.category,
                            style: const TextStyle(
                              color: AppColors.coralDark,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.mutedForeground,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ItemImage extends StatelessWidget {
  final String image;

  const _ItemImage({required this.image});

  @override
  Widget build(BuildContext context) {
    if (image.isEmpty) {
      return Container(color: AppColors.muted);
    }
    if (image.startsWith('http')) {
      return Image.network(image, fit: BoxFit.cover);
    }
    return Image.asset(image, fit: BoxFit.cover);
  }
}
