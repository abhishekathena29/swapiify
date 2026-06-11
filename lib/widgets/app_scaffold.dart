import 'package:flutter/material.dart';

import 'app_button.dart';
import 'app_chrome.dart';
import 'bottom_nav.dart';

/// Shared shell for the primary tab screens.
///
/// Wraps the [body] in the app backdrop, applies a top safe-area inset so
/// content never hides under the status bar/notch, and overlays the shared
/// floating [BottomNav] across every screen.
class AppScaffold extends StatelessWidget {
  final String currentRoute;
  final Widget body;

  const AppScaffold({
    super.key,
    required this.currentRoute,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackdrop(
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Positioned.fill(child: body),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: BottomNav(currentRoute: currentRoute),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Scaffold for pushed detail/sub screens (no bottom nav): backdrop, a top
/// safe-area inset so content never touches the status bar, a back button,
/// and a heading. [children] are laid out in a scrolling list below it.
class AppSubScreen extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String? subtitle;
  final List<Widget> children;

  const AppSubScreen({
    super.key,
    required this.eyebrow,
    required this.title,
    this.subtitle,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackdrop(
        child: SafeArea(
          bottom: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            children: [
              Row(
                children: [
                  AppButton(
                    icon: const Icon(Icons.arrow_back_rounded, size: 18),
                    onPressed: () => Navigator.pop(context),
                    variant: AppButtonVariant.outline,
                    size: AppButtonSize.icon,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              AppPanel(
                child: AppSectionHeading(
                  eyebrow: eyebrow,
                  title: title,
                  subtitle: subtitle,
                ),
              ),
              const SizedBox(height: 18),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}

/// A reusable grid of product cards plus loading/empty states, shared by the
/// listing surfaces.
class ProductGridState extends StatelessWidget {
  final bool isLoading;
  final bool hasError;
  final Widget grid;

  const ProductGridState({
    super.key,
    required this.isLoading,
    required this.hasError,
    required this.grid,
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
        child: Text('Something went wrong. Please try again.'),
      );
    }
    return grid;
  }
}
