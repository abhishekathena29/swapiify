import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/chat_thread.dart';
import '../models/message.dart';
import '../providers/auth_provider.dart';
import '../providers/chat_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/app_button.dart';
import '../widgets/app_chrome.dart';
import '../widgets/app_input.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;

  const ChatScreen({super.key, required this.chatId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send(ChatProvider provider) {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    provider.sendMessage(chatId: widget.chatId, text: text);
    _controller.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final chat = context.watch<ChatProvider>();
    final auth = context.watch<AuthProvider>();
    final currentUserId = auth.user?.uid;

    return Scaffold(
      body: AppBackdrop(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
            child: Column(
              children: [
                _Header(
                  chatId: widget.chatId,
                  currentUserId: currentUserId,
                  onBack: () => Navigator.pop(context),
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: currentUserId == null
                      ? const AppPanel(
                          child: Center(
                            child: Text('Sign in to view messages.'),
                          ),
                        )
                      : AppPanel(
                          padding: const EdgeInsets.all(14),
                          child: StreamBuilder<List<ChatMessage>>(
                            stream: chat.messagesStream(
                              chatId: widget.chatId,
                              currentUserId: currentUserId,
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              final messages =
                                  snapshot.data ?? const <ChatMessage>[];
                              if (messages.isEmpty) {
                                return const Center(
                                  child: Text(
                                    'No messages yet. Start the conversation.',
                                    style: TextStyle(
                                      color: AppColors.mutedForeground,
                                    ),
                                  ),
                                );
                              }
                              return ListView.builder(
                                controller: _scrollController,
                                itemCount: messages.length,
                                itemBuilder: (context, index) {
                                  return _MessageBubble(
                                    message: messages[index],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                ),
                const SizedBox(height: 12),
                AppPanel(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      AppButton(
                        icon: const Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 18,
                        ),
                        onPressed: () {},
                        variant: AppButtonVariant.outline,
                        size: AppButtonSize.icon,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: AppInput(
                          controller: _controller,
                          hintText: 'Write a message...',
                          onSubmitted: (_) => _send(chat),
                        ),
                      ),
                      const SizedBox(width: 10),
                      AppButton(
                        icon: const Icon(Icons.send_rounded, size: 18),
                        onPressed: () => _send(chat),
                        size: AppButtonSize.icon,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String chatId;
  final String? currentUserId;
  final VoidCallback onBack;

  const _Header({
    required this.chatId,
    required this.currentUserId,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final chat = context.read<ChatProvider>();

    return AppPanel(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          AppButton(
            icon: const Icon(Icons.arrow_back_rounded, size: 18),
            onPressed: onBack,
            variant: AppButtonVariant.outline,
            size: AppButtonSize.icon,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: currentUserId == null
                ? const Row(
                    children: [
                      AppAvatar(name: 'Chat'),
                      SizedBox(width: 12),
                      Text('Conversation'),
                    ],
                  )
                : StreamBuilder<ChatThread?>(
                    stream: chat.threadStream(
                      chatId: chatId,
                      currentUserId: currentUserId!,
                    ),
                    builder: (context, snapshot) {
                      final thread = snapshot.data;
                      final title = thread?.title ?? 'Conversation';
                      return Row(
                        children: [
                          AppAvatar(name: title),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'Available now',
                                  style: TextStyle(
                                    color: AppColors.mutedForeground,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
          AppButton(
            icon: const Icon(Icons.more_horiz_rounded, size: 18),
            onPressed: () {},
            variant: AppButtonVariant.outline,
            size: AppButtonSize.icon,
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isMe = message.sender == 'me';

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.72,
        ),
        decoration: BoxDecoration(
          color: isMe ? AppColors.plumDark : AppColors.cream,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(22),
            topRight: const Radius.circular(22),
            bottomLeft: Radius.circular(isMe ? 22 : 8),
            bottomRight: Radius.circular(isMe ? 8 : 22),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: isMe ? AppColors.cream : AppColors.foreground,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message.time,
              style: TextStyle(
                color: isMe
                    ? AppColors.cream.withValues(alpha: 0.62)
                    : AppColors.mutedForeground,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
