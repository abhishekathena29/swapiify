import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/app_user.dart';
import '../models/chat_thread.dart';
import '../models/message.dart';

class ChatProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  ChatProvider({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  Stream<List<ChatThread>> threadsStream({required String userId}) {
    return _firestore
        .collection('chats')
        .where('memberIds', arrayContains: userId)
        .orderBy('lastMessageAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) =>
                    ChatThread.fromSnapshot(doc: doc, currentUserId: userId),
              )
              .toList(),
        );
  }

  Stream<ChatThread?> threadStream({
    required String chatId,
    required String currentUserId,
  }) {
    return _firestore.collection('chats').doc(chatId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return ChatThread.fromSnapshot(doc: doc, currentUserId: currentUserId);
    });
  }

  Stream<List<ChatMessage>> messagesStream({
    required String chatId,
    required String currentUserId,
  }) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            final senderId = data['senderId'] as String? ?? '';
            final text = data['text'] as String? ?? '';
            final createdAt = (data['createdAt'] as Timestamp?)?.toDate();
            final time = _formatTime(createdAt);
            return ChatMessage(
              id: doc.id.hashCode,
              text: text,
              sender: senderId == currentUserId ? 'me' : 'other',
              time: time,
            );
          }).toList();
        });
  }

  Future<void> sendMessage({
    required String chatId,
    required String text,
  }) async {
    final senderId = _auth.currentUser?.uid;
    if (senderId == null) return;
    final messagesRef = _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages');
    await messagesRef.add({
      'text': text,
      'senderId': senderId,
      'createdAt': FieldValue.serverTimestamp(),
    });
    await _firestore.collection('chats').doc(chatId).set({
      'lastMessage': text,
      'lastMessageAt': FieldValue.serverTimestamp(),
      'lastMessageSenderId': senderId,
    }, SetOptions(merge: true));
  }

  Future<String> startChatWith({
    required AppUser currentUser,
    required String otherUserId,
    required String otherUserName,
  }) async {
    final memberIds = [currentUser.id, otherUserId]..sort();
    final membersKey = memberIds.join('_');
    final existing = await _firestore
        .collection('chats')
        .where('membersKey', isEqualTo: membersKey)
        .limit(1)
        .get();
    if (existing.docs.isNotEmpty) {
      return existing.docs.first.id;
    }
    final chatDoc = await _firestore.collection('chats').add({
      'memberIds': memberIds,
      'membersKey': membersKey,
      'memberSummaries': {
        currentUser.id: {'name': currentUser.name},
        otherUserId: {'name': otherUserName},
      },
      'lastMessage': '',
      'lastMessageAt': FieldValue.serverTimestamp(),
      'unreadCounts': {currentUser.id: 0, otherUserId: 0},
    });
    return chatDoc.id;
  }

  String _formatTime(DateTime? time) {
    if (time == null) return '';
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 1) return 'now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${time.month}/${time.day}/${time.year}';
  }
}
