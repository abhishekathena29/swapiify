import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppBadge extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback? onTap;

  const AppBadge({
    super.key,
    required this.label,
    this.active = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: active ? AppColors.plumDark : AppColors.card,
          border: Border.all(
            color: active ? AppColors.plumDark : AppColors.border,
          ),
          borderRadius: BorderRadius.circular(999),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: AppColors.plumDark.withValues(alpha: 0.14),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? AppColors.cream : AppColors.foreground,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
