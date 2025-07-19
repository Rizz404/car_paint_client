import 'package:flutter/material.dart';
import 'package:paint_car/core/constants/custom_colors.dart';
import 'package:paint_car/data/models/static_chat_notif.dart';
import 'package:paint_car/ui/shared/main_text.dart';

class ChatDetailPage extends StatefulWidget {
  final Bengkel bengkel;

  const ChatDetailPage({
    Key? key,
    required this.bengkel,
  }) : super(key: key);

  static route(Bengkel bengkel) => MaterialPageRoute(
        builder: (context) => ChatDetailPage(bengkel: bengkel),
      );

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _messageController = TextEditingController();
  late List<ChatMessage> _messages;

  @override
  void initState() {
    super.initState();
    _messages = widget.bengkel.messages;
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add(
          ChatMessage(
            text: _messageController.text,
            isMe: true,
            time: _getCurrentTime(),
          ),
        );
      });
      _messageController.clear();
    }
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(widget.bengkel.logoAsset),
              radius: 18,
              onBackgroundImageError: (_, __) {},
              backgroundColor: Colors.grey[200],
              child: const Icon(Icons.car_repair, color: Colors.grey, size: 18),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MainText(
                  text: widget.bengkel.name,
                  customTextStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                MainText(
                  text: widget.bengkel.status,
                  customTextStyle: TextStyle(
                    fontSize: 12,
                    color: widget.bengkel.status.toLowerCase() == 'online'
                        ? Colors.green
                        : Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Chat Date
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: MainText(
              text: 'Sun, 21 Apr, 07:03 PM',
              customTextStyle: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ),

          // Messages List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),

          // Message Input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: _sendMessage,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      // color: CustomColors.secondaryBlue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        // decoration: BoxDecoration(
        //   color: message.isMe ? CustomColors.secondaryBlue : Colors.grey[200],
        //   borderRadius: BorderRadius.circular(18),
        // ),
        // ! ini untuk membatasi lebar pesan, kenapa? karena pesan yang panjang akan membuat bubble melebar, jadi dikuranin lebarnya berapa persen dari layar
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            MainText(
              text: message.text,
              customTextStyle: TextStyle(
                color: message.isMe ? Colors.white : Colors.black87,
                fontSize: 15,
              ),
              maxLines: 10,
            ),
          ],
        ),
      ),
    );
  }
}
