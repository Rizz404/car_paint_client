class ChatMessage {
  final String text;
  final bool isMe;
  final String time;

  ChatMessage({
    required this.text,
    required this.isMe,
    required this.time,
  });
}

class Bengkel {
  final String id;
  final String name;
  final String logoAsset;
  final String status;
  final List<ChatMessage> messages;

  Bengkel({
    required this.id,
    required this.name,
    required this.logoAsset,
    required this.status,
    required this.messages,
  });
}

class NotificationItem {
  final String id;
  final String title;
  final String time;
  final bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.time,
    this.isRead = false,
  });
}
