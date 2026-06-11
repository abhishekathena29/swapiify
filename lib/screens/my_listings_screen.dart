import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/item.dart';
import '../providers/auth_provider.dart';
import '../providers/items_provider.dart';
import '../routes/app_router.dart';
import '../theme/app_colors.dart';
import '../widgets/app_button.dart';
import '../widgets/app_chrome.dart';
import '../widgets/app_scaffold.dart';
import '../widgets/product_card.dart';

class MyListingsScreen extends StatelessWidget {
  const MyListingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final items = context.read<ItemsProvider>();
    final uid = auth.user?.uid;

    return AppSubScreen(
      eyebrow: 'Your activity',
      title: 'My listings',
      subtitle: 'Items you have posted for swapping.',
      children: [
        if (uid == null)
          const AppPanel(child: Text('Sign in to view your listings.'))
        else
          StreamBuilder<List<Item>>(
            stream: items.userItemsStream(uid),
            builder: (context, snapshot) {
              final list = snapshot.data ?? const <Item>[];
              return AppPanel(
                child: ProductGridState(
                  isLoading:
                      snapshot.connectionState == ConnectionState.waiting,
                  hasError: snapshot.hasError,
                  grid: list.isEmpty
                      ? _EmptyState(
                          message:
                              'You have not listed anything yet. Post your first item to start swapping.',
                          actionLabel: 'Add an item',
                          onAction: () =>
                              Navigator.pushNamed(context, RouteNames.add),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${list.length} listing${list.length == 1 ? '' : 's'}',
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
              icon: const Icon(Icons.add_rounded, size: 18),
              onPressed: onAction,
            ),
          ],
        ],
      ),
    );
  }
}
