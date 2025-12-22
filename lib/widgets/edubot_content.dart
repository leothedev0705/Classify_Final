import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';

class EduBotContent extends StatefulWidget {
  const EduBotContent({Key? key}) : super(key: key);

  @override
  _EduBotContentState createState() => _EduBotContentState();
}

class _EduBotContentState extends State<EduBotContent> {
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFEDEEF2),
      padding: const EdgeInsets.all(24),
      child: Consumer<ChatProvider>(
        builder: (context, chat, _) => Column(
        children: [
          // Chat messages area
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: chat.messages.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 64,
                            color: const Color(0xFF353E6C).withOpacity(0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Start a conversation with EduBot',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              color: const Color(0xFF353E6C).withOpacity(0.5),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: chat.messages.length,
                      itemBuilder: (context, index) {
                        final m = chat.messages[index];
                        return _buildChatBubble(ChatMessage(text: m['text'], isUser: m['sender'] == 'user', isWarning: m['isWarning'] == true));
                      },
                    ),
            ),
          ),
          const SizedBox(height: 16),
          // Input field
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFC5C7D0), width: 1),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    enabled: !chat.isDisabled,
                    decoration: const InputDecoration(
                      hintText: 'Ask EduBot anything...',
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: false,
                      contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                    onSubmitted: (_) => _sendMessage(chat),
                  ),
                ),
                Container(
                  height: 44,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2E3A59),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(7),
                      bottomRight: Radius.circular(7),
                    ),
                  ),
                  child: TextButton(
                    onPressed: chat.isDisabled ? null : () => _sendMessage(chat),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(7),
                          bottomRight: Radius.circular(7),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Send',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
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

  Widget _buildChatBubble(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.6,
        ),
        decoration: BoxDecoration(
          color: message.isUser
              ? const Color(0xFF353E6C)
              : (message.isWarning ? Colors.orange.withOpacity(0.1) : const Color(0xFFEDEEF2)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            color: message.isUser ? Colors.white : (message.isWarning ? Colors.orange : const Color(0xFF353E6C)),
          ),
        ),
      ),
    );
  }

  void _sendMessage(ChatProvider chat) {
    final text = messageController.text.trim();
    if (text.isNotEmpty) {
      chat.sendMessage(text);
      messageController.clear();
    }
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final bool isWarning;

  ChatMessage({required this.text, required this.isUser, this.isWarning = false});
}

