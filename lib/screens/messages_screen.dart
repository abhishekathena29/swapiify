import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/chat_thread.dart';
import '../providers/auth_provider.dart';
import '../providers/chat_provider.dart';
import '../routes/app_router.dart';
import '../theme/app_colors.dart';
import '../widgets/app_chrome.dart';
import '../widgets/app_input.dart';
import '../widgets/bottom_nav.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final chatProvider = context.read<ChatProvider>();
    final userId = auth.user?.uid;

    return Scaffold(
      body: AppBackdrop(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
              children: [
                const _Header(),
                const SizedBox(height: 18),
                if (userId == null)
                  const AppPanel(
                    child: Text(
                      'Sign in to view conversations and coordinate swaps.',
                      style: TextStyle(color: AppColors.mutedForeground),
                    ),
                  )
                else
                  StreamBuilder<List<ChatThread>>(
                    stream: chatProvider.threadsStream(userId: userId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const AppPanel(
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        );
                      }
                      final threads = snapshot.data ?? const <ChatThread>[];
                      if (threads.isEmpty) {
                        return AppPanel(
                          color: AppColors.highlight,
                          child: const Text(
                            'No conversations yet. Start from any product to message a seller.',
                            style: TextStyle(color: AppColors.mutedForeground),
                          ),
                        );
                      }
                      return AppPanel(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: threads.map((thread) {
                            return _ThreadTile(thread: thread);
                          }).toList(),
                        ),
                      );
                    },
                  ),
              ],
            ),
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: BottomNav(currentRoute: RouteNames.messages),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return AppPanel(
      child: Column(
        children: const [
          AppSectionHeading(
            eyebrow: 'Inbox',
            title: 'Conversations that move a swap forward.',
            subtitle:
                'Recent threads stay readable, lightweight, and easy to pick back up.',
          ),
          SizedBox(height: 18),
          AppInput(
            hintText: 'Search conversations...',
            prefixIcon: Icon(Icons.search_rounded),
          ),
        ],
      ),
    );
  }
}

class _ThreadTile extends StatelessWidget {
  final ChatThread thread;

  const _ThreadTile({required this.thread});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>
          Navigator.pushNamed(context, '${RouteNames.chat}/${thread.id}'),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: thread.unread > 0 ? AppColors.highlight : AppColors.cream,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                AppAvatar(name: thread.title),
                if (thread.unread > 0)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: const BoxDecoration(
                        color: AppColors.coralDark,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${thread.unread}',
                          style: const TextStyle(
                            color: AppColors.cream,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          thread.title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: thread.unread > 0
                                ? FontWeight.w700
                                : FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        _formatTime(thread.lastMessageAt),
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    thread.lastMessage.isEmpty
                        ? 'Say hello and start the exchange.'
                        : thread.lastMessage,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: thread.unread > 0
                          ? AppColors.foreground
                          : AppColors.mutedForeground,
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

String _formatTime(DateTime? time) {
  if (time == null) return '';
  final now = DateTime.now();
  final diff = now.difference(time);
  if (diff.inMinutes < 1) return 'now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m';
  if (diff.inHours < 24) return '${diff.inHours}h';
  if (diff.inDays < 7) return '${diff.inDays}d';
  return '${time.month}/${time.day}';
}
