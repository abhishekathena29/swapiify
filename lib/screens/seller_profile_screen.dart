import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_user.dart';
import '../providers/auth_provider.dart';
import '../providers/chat_provider.dart';
import '../routes/app_router.dart';
import '../theme/app_colors.dart';
import '../widgets/app_button.dart';
import '../widgets/app_chrome.dart';

class SellerProfileScreen extends StatelessWidget {
  final String sellerId;

  const SellerProfileScreen({super.key, required this.sellerId});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final chatProvider = context.read<ChatProvider>();

    return Scaffold(
      body: AppBackdrop(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
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
              const SizedBox(height: 14),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(sellerId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const AppPanel(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    );
                  }
                  if (!snapshot.hasData || !(snapshot.data?.exists ?? false)) {
                    return const AppPanel(
                      child: Text('Seller profile not found.'),
                    );
                  }
                  final profile = AppUser.fromDoc(snapshot.data!);
                  return Column(
                    children: [
                      AppPanel(
                        color: AppColors.plumDark,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                AppAvatar(
                                  name: profile.name,
                                  size: 76,
                                  inverse: true,
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        profile.name,
                                        style: const TextStyle(
                                          color: AppColors.cream,
                                          fontSize: 28,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'Playfair Display',
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        profile.email,
                                        style: TextStyle(
                                          color: AppColors.cream.withValues(
                                            alpha: 0.72,
                                          ),
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
                                  child: _Stat(
                                    label: 'Swaps',
                                    value: '${profile.swaps}',
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _Stat(
                                    label: 'Rating',
                                    value: profile.rating.toStringAsFixed(1),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _Stat(
                                    label: 'Followers',
                                    value: '${profile.followers}',
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const AppSectionHeading(
                              eyebrow: 'Swap confidence',
                              title:
                                  'A profile designed to feel credible at a glance.',
                              subtitle:
                                  'Ratings, completed swaps, and direct contact all stay visible and clear.',
                            ),
                            const SizedBox(height: 18),
                            AppButton(
                              label: 'Message seller',
                              icon: const Icon(Icons.message_rounded, size: 18),
                              onPressed: auth.profile == null
                                  ? null
                                  : () async {
                                      final chatId = await chatProvider
                                          .startChatWith(
                                            currentUser: auth.profile!,
                                            otherUserId: sellerId,
                                            otherUserName: profile.name,
                                          );
                                      if (!context.mounted) return;
                                      Navigator.pushNamed(
                                        context,
                                        '${RouteNames.chat}/$chatId',
                                      );
                                    },
                              fullWidth: true,
                              size: AppButtonSize.xl,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;

  const _Stat({required this.label, required this.value});

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
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: AppColors.cream.withValues(alpha: 0.7),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
