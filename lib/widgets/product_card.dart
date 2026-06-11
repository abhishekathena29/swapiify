import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/item.dart';
import '../providers/favorites_provider.dart';
import '../routes/app_router.dart';
import '../theme/app_colors.dart';

/// Renders a product image from a network URL, a bundled asset, or a
/// neutral placeholder when no image is available.
class ProductImage extends StatelessWidget {
  final String image;
  final BoxFit fit;

  const ProductImage({super.key, required this.image, this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    if (image.isEmpty) {
      return Container(
        color: AppColors.muted,
        child: const Center(
          child: Icon(
            Icons.image_outlined,
            color: AppColors.mutedForeground,
          ),
        ),
      );
    }
    if (image.startsWith('http')) {
      return Image.network(
        image,
        fit: fit,
        errorBuilder: (_, _, _) => Container(color: AppColors.muted),
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            color: AppColors.muted,
            child: const Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        },
      );
    }
    return Image.asset(image, fit: fit);
  }
}

/// Shared listing card used across Home, Browse, My Listings and Saved Items
/// so every product surface looks and behaves identically.
class ProductCard extends StatelessWidget {
  final String id;
  final String title;
  final String image;
  final String category;
  final String location;
  final bool isFavorite;
  final VoidCallback? onToggleFavorite;

  const ProductCard({
    super.key,
    required this.id,
    required this.title,
    required this.image,
    required this.category,
    required this.location,
    this.isFavorite = false,
    this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>
          Navigator.pushNamed(context, '${RouteNames.product}/$id'),
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
                      child: ProductImage(image: image),
                    ),
                  ),
                  if (onToggleFavorite != null)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: InkWell(
                        onTap: onToggleFavorite,
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
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category,
                    style: const TextStyle(
                      color: AppColors.coralDark,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    location,
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
  }
}

/// A responsive two-column grid of [ProductCard]s built from [Item]s, with
/// favorite state wired to [FavoritesProvider]. Shared by every listing screen.
class ItemCardGrid extends StatelessWidget {
  final List<Item> items;

  const ItemCardGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>();
    return GridView.builder(
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
        return ProductCard(
          id: item.id,
          title: item.title,
          image: image,
          category: item.category,
          location: item.location,
          isFavorite: favorites.isFavorite(item.id),
          onToggleFavorite: () =>
              context.read<FavoritesProvider>().toggle(item.id),
        );
      },
    );
  }
}
