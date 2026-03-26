import 'package:cloud_firestore/cloud_firestore.dart';

class ChatThread {
  final String id;
  final String title;
  final String lastMessage;
  final DateTime? lastMessageAt;
  final int unread;
  final String otherUserId;

  const ChatThread({
    required this.id,
    required this.title,
    required this.lastMessage,
    required this.lastMessageAt,
    required this.unread,
    required this.otherUserId,
  });

  factory ChatThread.fromSnapshot({
    required DocumentSnapshot<Map<String, dynamic>> doc,
    required String currentUserId,
  }) {
    final data = doc.data() ?? <String, dynamic>{};
    final memberIds =
        (data['memberIds'] as List?)?.whereType<String>().toList() ??
        const <String>[];
    final otherUserId = memberIds.firstWhere(
      (id) => id != currentUserId,
      orElse: () => currentUserId,
    );
    final summaries =
        (data['memberSummaries'] as Map?)?.cast<String, dynamic>() ??
        <String, dynamic>{};
    final otherSummary =
        (summaries[otherUserId] as Map?)?.cast<String, dynamic>() ??
        <String, dynamic>{};

    return ChatThread(
      id: doc.id,
      title: (otherSummary['name'] as String?) ?? 'Conversation',
      lastMessage: (data['lastMessage'] as String?) ?? '',
      lastMessageAt: (data['lastMessageAt'] as Timestamp?)?.toDate(),
      unread:
          (data['unreadCounts'] as Map?)?.cast<String, dynamic>()[currentUserId]
              as int? ??
          0,
      otherUserId: otherUserId,
    );
  }
}
