import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/app_chrome.dart';
import '../widgets/app_scaffold.dart';

class SwapHistoryScreen extends StatelessWidget {
  const SwapHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final uid = auth.user?.uid;

    return AppSubScreen(
      eyebrow: 'Your activity',
      title: 'Swap history',
      subtitle: 'Completed exchanges you have been part of.',
      children: [
        if (uid == null)
          const AppPanel(child: Text('Sign in to view your swap history.'))
        else
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('swaps')
                .where('memberIds', arrayContains: uid)
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

              final docs = snapshot.data?.docs ?? const [];
              if (docs.isEmpty) {
                return const AppPanel(child: _EmptyHistory());
              }

              final swaps = docs.map((doc) => doc.data()).toList()
                ..sort((a, b) {
                  final ta = (a['completedAt'] as Timestamp?)?.toDate();
                  final tb = (b['completedAt'] as Timestamp?)?.toDate();
                  if (ta == null && tb == null) return 0;
                  if (ta == null) return 1;
                  if (tb == null) return -1;
                  return tb.compareTo(ta);
                });

              return AppPanel(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: swaps.map((data) => _SwapTile(data: data)).toList(),
                ),
              );
            },
          ),
      ],
    );
  }
}

class _SwapTile extends StatelessWidget {
  final Map<String, dynamic> data;

  const _SwapTile({required this.data});

  @override
  Widget build(BuildContext context) {
    final title = (data['itemTitle'] as String?) ?? 'Swapped item';
    final withName = (data['withName'] as String?) ?? 'Another swapper';
    final status = (data['status'] as String?) ?? 'Completed';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.highlight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.swap_horiz_rounded,
              color: AppColors.plumDark,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 3),
                Text(
                  'with $withName',
                  style: const TextStyle(
                    color: AppColors.mutedForeground,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.highlight,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              status,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.plumDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8),
      child: Text(
        'No completed swaps yet. Once you finish an exchange, it will show up here.',
        style: TextStyle(color: AppColors.mutedForeground, height: 1.45),
      ),
    );
  }
}
