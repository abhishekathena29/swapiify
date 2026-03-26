class ChatMessage {
  final int id;
  final String text;
  final String sender; // "me" or "other"
  final String time;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.sender,
    required this.time,
  });
}
