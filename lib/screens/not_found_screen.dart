import 'package:flutter/material.dart';

import '../routes/app_router.dart';
import '../theme/app_colors.dart';
import '../widgets/app_button.dart';
import '../widgets/app_chrome.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackdrop(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: AppPanel(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '404',
                      style: TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Playfair Display',
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'That page wandered off.',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Return to the home feed and continue browsing nearby swaps.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.mutedForeground,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 18),
                    AppButton(
                      label: 'Go home',
                      onPressed: () => Navigator.pushReplacementNamed(
                        context,
                        RouteNames.home,
                      ),
                      size: AppButtonSize.xl,
                      fullWidth: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
