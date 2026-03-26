class Conversation {
  final String id;
  final String name;
  final String lastMessage;
  final String time;
  final int unread;

  const Conversation({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.unread,
  });
}
