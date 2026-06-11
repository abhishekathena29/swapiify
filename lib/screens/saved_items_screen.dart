import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/item.dart';
import '../providers/auth_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/items_provider.dart';
import '../routes/app_router.dart';
import '../theme/app_colors.dart';
import '../widgets/app_button.dart';
import '../widgets/app_chrome.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/product_card.dart';

class SavedItemsScreen extends StatelessWidget {
  const SavedItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final favorites = context.watch<FavoritesProvider>();
    final items = context.read<ItemsProvider>();
    final uid = auth.user?.uid;
    final savedIds = favorites.savedIds.toList();

    return AppSubScreen(
      eyebrow: 'Your activity',
      title: 'Saved items',
      subtitle: 'Listings you bookmarked to revisit later.',
      children: [
        if (uid == null)
          const AppPanel(child: Text('Sign in to view saved items.'))
        else if (savedIds.isEmpty)
          AppPanel(
            child: _EmptyState(
              message:
                  'You have not saved anything yet. Tap the heart on any listing to keep it here.',
              actionLabel: 'Browse items',
              onAction: () => Navigator.pushNamed(context, RouteNames.browse),
            ),
          )
        else
          FutureBuilder<List<Item>>(
            // Re-fetch whenever the set of saved ids changes.
            key: ValueKey(savedIds.join(',')),
            future: items.itemsByIds(savedIds),
            builder: (context, snapshot) {
              final list = snapshot.data ?? const <Item>[];
              return AppPanel(
                child: ProductGridState(
                  isLoading:
                      snapshot.connectionState == ConnectionState.waiting,
                  hasError: snapshot.hasError,
                  grid: list.isEmpty
                      ? const _EmptyState(
                          message:
                              'Your saved listings are no longer available.',
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${list.length} saved',
                              style: const TextStyle(
                                color: AppColors.mutedForeground,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ItemCardGrid(items: list),
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

class _EmptyState extends StatelessWidget {
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _EmptyState({required this.message, this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.highlight,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: const TextStyle(
              color: AppColors.mutedForeground,
              height: 1.45,
            ),
          ),
          if (actionLabel != null) ...[
            const SizedBox(height: 16),
            AppButton(
              label: actionLabel!,
              icon: const Icon(Icons.search_rounded, size: 18),
              onPressed: onAction,
            ),
          ],
        ],
      ),
    );
  }
}
