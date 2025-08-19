import 'package:flutter/material.dart';
import 'package:bank_sha/shared/theme.dart';
import 'package:bank_sha/services/chat_service.dart';

class ChatIconWithBadge extends StatefulWidget {
  final VoidCallback? onTap;

  const ChatIconWithBadge({
    super.key,
    this.onTap,
  });

  @override
  State<ChatIconWithBadge> createState() => _ChatIconWithBadgeState();
}

class _ChatIconWithBadgeState extends State<ChatIconWithBadge> {
  final ChatService _chatService = ChatService();
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    _initializeAndListenToChats();
  }

  void _initializeAndListenToChats() async {
    // Initialize chat service
    await _chatService.initializeData();
    
    // Get initial unread count
    _updateUnreadCount();
    
    // Listen to conversation updates
    _chatService.conversationsStream.listen((conversations) {
      if (mounted) {
        _updateUnreadCount();
      }
    });
  }

  void _updateUnreadCount() {
    final newCount = _chatService.getTotalUnreadCount();
    if (mounted && newCount != _unreadCount) {
      setState(() {
        _unreadCount = newCount;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            child: Icon(
              Icons.chat_bubble_outline,
              color: blackColor,
              size: 24,
            ),
          ),
          if (_unreadCount > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: redcolor,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: Text(
                  _unreadCount > 99 ? '99+' : _unreadCount.toString(),
                  style: whiteTextStyle.copyWith(
                    fontSize: 9,
                    fontWeight: bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
