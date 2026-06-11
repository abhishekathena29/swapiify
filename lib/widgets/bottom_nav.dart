import 'package:flutter/material.dart';

import '../routes/app_router.dart';
import '../theme/app_colors.dart';

class BottomNav extends StatelessWidget {
  final String currentRoute;

  const BottomNav({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    final items = <_NavItem>[
      _NavItem('Home', Icons.home_rounded, RouteNames.home),
      _NavItem('Browse', Icons.search_rounded, RouteNames.browse),
      _NavItem('Add', Icons.add_circle_outline, RouteNames.add, isMain: true),
      _NavItem('Messages', Icons.message_rounded, RouteNames.messages),
      _NavItem('Profile', Icons.person_rounded, RouteNames.profile),
    ];

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.card.withValues(alpha: 0.96),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: AppColors.plumDark.withValues(alpha: 0.08),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: SizedBox(
            height: 64,
            child: Row(
              children: items.map((item) {
                if (item.isMain) {
                  return _MainNavButton(item: item);
                }
                final isActive = currentRoute == item.route;
                return Expanded(
                  child: _NavButton(
                    item: item,
                    isActive: isActive,
                    onTap: () => _navigate(context, item.route, currentRoute),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  void _navigate(BuildContext context, String route, String current) {
    if (route == current) return;
    Navigator.pushReplacementNamed(context, route);
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final String route;
  final bool isMain;

  const _NavItem(this.label, this.icon, this.route, {this.isMain = false});
}

class _NavButton extends StatelessWidget {
  final _NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _NavButton({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        height: 52,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          color: isActive ? AppColors.highlight : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              item.icon,
              size: 20,
              color: isActive ? AppColors.plumDark : AppColors.mutedForeground,
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isActive
                    ? AppColors.plumDark
                    : AppColors.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MainNavButton extends StatelessWidget {
  final _NavItem item;

  const _MainNavButton({required this.item});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -14),
      child: InkWell(
        onTap: () => Navigator.pushReplacementNamed(context, item.route),
        borderRadius: BorderRadius.circular(999),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.coral, AppColors.coralDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.coralDark.withValues(alpha: 0.32),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(item.icon, color: AppColors.cream, size: 26),
        ),
      ),
    );
  }
}
