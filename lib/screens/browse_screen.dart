import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/item.dart';
import '../providers/items_provider.dart';
import '../routes/app_router.dart';
import '../theme/app_colors.dart';
import '../widgets/app_badge.dart';
import '../widgets/app_button.dart';
import '../widgets/app_chrome.dart';
import '../widgets/app_input.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/product_card.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  String _activeCategory = 'All';

  @override
  Widget build(BuildContext context) {
    final itemsProvider = context.read<ItemsProvider>();

    return AppScaffold(
      currentRoute: RouteNames.browse,
      body: StreamBuilder<List<Item>>(
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
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 130),
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
  final List<Item> items;
  final bool isLoading;
  final bool hasError;

  const _BrowseGrid({
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
        ItemCardGrid(items: items),
      ],
    );
  }
}
