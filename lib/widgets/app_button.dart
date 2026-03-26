import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

enum AppButtonVariant {
  coral,
  coralOutline,
  plumOutline,
  outline,
  ghost,
  link,
  hero,
}

enum AppButtonSize { sm, lg, xl, icon }

class AppButton extends StatelessWidget {
  final String? label;
  final Widget? icon;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool fullWidth;

  const AppButton({
    super.key,
    this.label,
    this.icon,
    required this.onPressed,
    this.variant = AppButtonVariant.coral,
    this.size = AppButtonSize.lg,
    this.fullWidth = false,
  }) : assert(label != null || icon != null, 'Provide label or icon');

  @override
  Widget build(BuildContext context) {
    final styles = _styles(context);
    final content = _content(context);

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: styles.height,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: styles.background,
          foregroundColor: styles.foreground,
          padding: styles.padding,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(styles.radius),
            side: styles.border,
          ),
        ),
        child: content,
      ),
    );
  }

  _ButtonStyles _styles(BuildContext context) {
    final isIconOnly = size == AppButtonSize.icon;
    final height = switch (size) {
      AppButtonSize.sm => 36.0,
      AppButtonSize.lg => 48.0,
      AppButtonSize.xl => 56.0,
      AppButtonSize.icon => 48.0,
    };

    final padding = isIconOnly
        ? const EdgeInsets.all(0)
        : const EdgeInsets.symmetric(horizontal: 18, vertical: 12);

    Color background;
    Color foreground;
    BorderSide border = BorderSide.none;

    switch (variant) {
      case AppButtonVariant.coral:
        background = AppColors.coral;
        foreground = AppColors.cream;
        break;
      case AppButtonVariant.hero:
        background = AppColors.cream;
        foreground = AppColors.plumDark;
        border = const BorderSide(color: AppColors.creamDark);
        break;
      case AppButtonVariant.coralOutline:
        background = AppColors.card;
        foreground = AppColors.coralDark;
        border = const BorderSide(color: AppColors.coralLight, width: 1.2);
        break;
      case AppButtonVariant.plumOutline:
        background = AppColors.card;
        foreground = AppColors.plumDark;
        border = const BorderSide(color: AppColors.border, width: 1.2);
        break;
      case AppButtonVariant.outline:
        background = AppColors.card;
        foreground = AppColors.foreground;
        border = const BorderSide(color: AppColors.border, width: 1.2);
        break;
      case AppButtonVariant.ghost:
        background = AppColors.muted.withValues(alpha: 0.5);
        foreground = AppColors.mutedForeground;
        break;
      case AppButtonVariant.link:
        background = Colors.transparent;
        foreground = AppColors.coralDark;
        break;
    }

    return _ButtonStyles(
      height: height,
      padding: padding,
      background: background,
      foreground: foreground,
      border: border,
      radius: isIconOnly ? 22 : 20,
    );
  }

  Widget _content(BuildContext context) {
    final text = label;
    if (text == null) return icon ?? const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[icon!, const SizedBox(width: 8)],
        Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: size == AppButtonSize.sm ? 12 : 14,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}

class _ButtonStyles {
  final double height;
  final EdgeInsets padding;
  final Color background;
  final Color foreground;
  final BorderSide border;
  final double radius;

  const _ButtonStyles({
    required this.height,
    required this.padding,
    required this.background,
    required this.foreground,
    required this.border,
    required this.radius,
  });
}
