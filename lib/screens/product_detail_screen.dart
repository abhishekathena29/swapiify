import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/item.dart';
import '../providers/auth_provider.dart';
import '../providers/chat_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/items_provider.dart';
import '../routes/app_router.dart';
import '../theme/app_colors.dart';
import '../widgets/app_button.dart';
import '../widgets/app_chrome.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _currentImage = 0;

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>();
    final itemsProvider = context.read<ItemsProvider>();
    final auth = context.watch<AuthProvider>();
    final chatProvider = context.read<ChatProvider>();

    return Scaffold(
      body: AppBackdrop(
        child: Stack(
          children: [
            StreamBuilder<Item?>(
              stream: itemsProvider.itemStream(widget.productId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SafeArea(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final firestoreItem = snapshot.data;
                if (firestoreItem == null) {
                  return SafeArea(
                    bottom: false,
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                      children: [
                        _TopBar(
                          onBack: () => Navigator.pop(context),
                          isFavorite: false,
                          onToggleFavorite: () {},
                        ),
                        const SizedBox(height: 18),
                        const AppPanel(
                          child: Text(
                            'This listing is no longer available.',
                            style: TextStyle(color: AppColors.mutedForeground),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                final product = firestoreItem.toProduct();
                final images = product.images;
                final isFavorite = favorites.isFavorite(product.id);
                final sellerId = firestoreItem.ownerId;
                final sellerName = firestoreItem.ownerName;

                return SafeArea(
                  bottom: false,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 118),
                    children: [
                    _TopBar(
                      onBack: () => Navigator.pop(context),
                      isFavorite: isFavorite,
                      onToggleFavorite: () => favorites.toggle(product.id),
                    ),
                    const SizedBox(height: 14),
                    _Gallery(
                      images: images,
                      currentIndex: _currentImage,
                      onIndexChanged: (value) =>
                          setState(() => _currentImage = value),
                    ),
                    const SizedBox(height: 18),
                    AppPanel(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.category.toUpperCase(),
                            style: const TextStyle(
                              color: AppColors.coralDark,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.3,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            product.name,
                            style: const TextStyle(
                              fontSize: 30,
                              height: 1.1,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Playfair Display',
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              _MetaChip(
                                icon: Icons.location_on_outlined,
                                label: product.location,
                              ),
                              _MetaChip(
                                icon: Icons.schedule_rounded,
                                label: product.postedAgo.isEmpty
                                    ? 'Just now'
                                    : product.postedAgo,
                              ),
                              _MetaChip(
                                icon: Icons.verified_outlined,
                                label: product.condition,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'About this item',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            product.description,
                            style: const TextStyle(
                              color: AppColors.mutedForeground,
                              height: 1.55,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.highlight,
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Preferred exchange',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  product.wantsInReturn,
                                  style: const TextStyle(
                                    color: AppColors.mutedForeground,
                                    height: 1.45,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.cream,
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: Row(
                              children: [
                                AppAvatar(name: sellerName, inverse: true),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        sellerName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        '${product.seller.rating.toStringAsFixed(1)} rating • ${product.seller.swaps} swaps',
                                        style: const TextStyle(
                                          color: AppColors.mutedForeground,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                AppButton(
                                  label: 'Profile',
                                  onPressed: () {
                                    if (sellerId.isEmpty) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Seller profile not available.',
                                          ),
                                        ),
                                      );
                                      return;
                                    }
                                    Navigator.pushNamed(
                                      context,
                                      '${RouteNames.seller}/$sellerId',
                                    );
                                  },
                                  variant: AppButtonVariant.outline,
                                  size: AppButtonSize.sm,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    ],
                  ),
                );
              },
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
                  child: AppPanel(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        AppButton(
                          icon: const Icon(Icons.message_rounded, size: 18),
                          onPressed: () async {
                            final snapshot = await itemsProvider
                                .itemStream(widget.productId)
                                .first;
                            final sellerId = snapshot?.ownerId;
                            final sellerName = snapshot?.ownerName ?? 'Seller';

                            if (auth.profile == null) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Please sign in to message sellers.',
                                  ),
                                ),
                              );
                              return;
                            }
                            if (sellerId == null) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Unable to start chat for this item.',
                                  ),
                                ),
                              );
                              return;
                            }

                            final chatId = await chatProvider.startChatWith(
                              currentUser: auth.profile!,
                              otherUserId: sellerId,
                              otherUserName: sellerName,
                            );
                            if (!context.mounted) return;
                            Navigator.pushNamed(
                              context,
                              '${RouteNames.chat}/$chatId',
                            );
                          },
                          variant: AppButtonVariant.outline,
                          size: AppButtonSize.icon,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppButton(
                            label: 'Make an offer',
                            icon: const Icon(
                              Icons.auto_awesome_rounded,
                              size: 18,
                            ),
                            onPressed: () {},
                            size: AppButtonSize.xl,
                            fullWidth: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final VoidCallback onBack;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  const _TopBar({
    required this.onBack,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppButton(
          icon: const Icon(Icons.arrow_back_rounded, size: 18),
          onPressed: onBack,
          variant: AppButtonVariant.outline,
          size: AppButtonSize.icon,
        ),
        const Spacer(),
        AppButton(
          icon: Icon(
            isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            size: 18,
          ),
          onPressed: onToggleFavorite,
          variant: AppButtonVariant.outline,
          size: AppButtonSize.icon,
        ),
      ],
    );
  }
}

class _Gallery extends StatelessWidget {
  final List<String> images;
  final int currentIndex;
  final ValueChanged<int> onIndexChanged;

  const _Gallery({
    required this.images,
    required this.currentIndex,
    required this.onIndexChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1.08,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: PageView.builder(
                itemCount: images.length,
                onPageChanged: onIndexChanged,
                itemBuilder: (context, index) {
                  final image = images[index];
                  if (image.startsWith('http')) {
                    return Image.network(image, fit: BoxFit.cover);
                  }
                  return Image.asset(image, fit: BoxFit.cover);
                },
              ),
            ),
          ),
          if (images.length > 1) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(images.length, (index) {
                final active = index == currentIndex;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: active ? 28 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: active ? AppColors.plumDark : AppColors.border,
                    borderRadius: BorderRadius.circular(999),
                  ),
                );
              }),
            ),
          ],
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.coralDark),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
