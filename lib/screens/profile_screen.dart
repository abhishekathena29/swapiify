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

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final favorites = context.watch<FavoritesProvider>();
    final items = context.read<ItemsProvider>();
    final profile = auth.profile;
    final uid = auth.user?.uid;

    return AppScaffold(
      currentRoute: RouteNames.profile,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 130),
        children: [
          AppPanel(
            color: AppColors.plumDark,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          AppAvatar(
                            name: profile?.name ?? 'User',
                            size: 72,
                            inverse: true,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  profile?.name ?? 'User',
                                  style: const TextStyle(
                                    color: AppColors.cream,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Playfair Display',
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  profile?.email ?? 'No email available',
                                  style: TextStyle(
                                    color: AppColors.cream.withValues(
                                      alpha: 0.74,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _memberSince(profile?.createdAt),
                                  style: TextStyle(
                                    color: AppColors.cream.withValues(
                                      alpha: 0.6,
                                    ),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              label: 'Swaps',
                              value: '${profile?.swaps ?? 0}',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _StatCard(
                              label: 'Rating',
                              value: (profile?.rating ?? 0).toStringAsFixed(1),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _StatCard(
                              label: 'Followers',
                              value: '${profile?.followers ?? 0}',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                AppPanel(
                  child: Column(
                    children: [
                      const AppSectionHeading(
                        eyebrow: 'Account',
                        title: 'Everything around your swapping identity.',
                        subtitle:
                            'Listings, favorites, history, and account controls in one place.',
                      ),
                      const SizedBox(height: 18),
                      _MenuTile(
                        icon: Icons.inventory_2_outlined,
                        label: 'My listings',
                        subtitle: 'Manage what you have available to trade.',
                        emphasis: true,
                        trailing: uid == null
                            ? null
                            : StreamBuilder<List<Item>>(
                                stream: items.userItemsStream(uid),
                                builder: (context, snapshot) =>
                                    _CountLabel('${snapshot.data?.length ?? 0}'),
                              ),
                        onTap: () => Navigator.pushNamed(
                          context,
                          RouteNames.myListings,
                        ),
                      ),
                      _MenuTile(
                        icon: Icons.favorite_border_rounded,
                        label: 'Saved items',
                        subtitle: 'Keep an eye on listings you may want later.',
                        trailing: _CountLabel('${favorites.savedIds.length}'),
                        onTap: () => Navigator.pushNamed(
                          context,
                          RouteNames.savedItems,
                        ),
                      ),
                      _MenuTile(
                        icon: Icons.history_rounded,
                        label: 'Swap history',
                        subtitle: 'Look back at completed exchanges.',
                        trailing: _CountLabel('${profile?.swaps ?? 0}'),
                        onTap: () => Navigator.pushNamed(
                          context,
                          RouteNames.swapHistory,
                        ),
                      ),
                      _MenuTile(
                        icon: Icons.tune_rounded,
                        label: 'Settings',
                        subtitle: 'Privacy, alerts, and account preferences.',
                        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Settings are coming soon.'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      AppButton(
                        label: 'Log out',
                        icon: const Icon(Icons.logout_rounded, size: 18),
                        onPressed: () async {
                          await auth.signOut();
                          if (!context.mounted) return;
                          Navigator.pushReplacementNamed(
                            context,
                            RouteNames.login,
                          );
                        },
                        variant: AppButtonVariant.outline,
                        fullWidth: true,
                        size: AppButtonSize.xl,
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  String _memberSince(DateTime? date) {
    if (date == null) return 'Member since recently';
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return 'Member since ${months[date.month - 1]} ${date.year}';
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.cream.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: AppColors.cream,
              fontWeight: FontWeight.w700,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: AppColors.cream.withValues(alpha: 0.72),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final bool emphasis;
  final Widget? trailing;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
    this.emphasis = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: emphasis ? AppColors.highlight : AppColors.cream,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: AppColors.plumDark),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.mutedForeground,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) ...[trailing!, const SizedBox(width: 6)],
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.mutedForeground,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CountLabel extends StatelessWidget {
  final String value;

  const _CountLabel(this.value);

  @override
  Widget build(BuildContext context) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Text(
      value,
      style: const TextStyle(
        color: AppColors.mutedForeground,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
