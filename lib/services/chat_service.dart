import 'dart:async';
import 'dart:math';
import '../models/chat_model.dart';
import '../services/local_storage_service.dart';
import '../services/gemini_ai_service.dart';

class ChatService {
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();

  final StreamController<List<ChatConversation>> _conversationsController =
      StreamController<List<ChatConversation>>.broadcast();
  
  final StreamController<List<ChatMessage>> _messagesController =
      StreamController<List<ChatMessage>>.broadcast();

  Stream<List<ChatConversation>> get conversationsStream => _conversationsController.stream;
  Stream<List<ChatMessage>> get messagesStream => _messagesController.stream;

  List<ChatConversation> _conversations = [];
  List<ChatMessage> _currentMessages = [];
  late LocalStorageService _localStorage;

  // Initialize with local storage
  Future<void> initializeData() async {
    _localStorage = await LocalStorageService.getInstance();
    await _loadConversationsFromStorage();
  }

  Future<void> _loadConversationsFromStorage() async {
    final storedConversations = await _localStorage.getConversations();
    
    if (storedConversations.isNotEmpty) {
      _conversations = storedConversations.map((data) => ChatConversation.fromJson(data)).toList();
    } else {
      // Initialize with sample data if no stored data
      _conversations = [
        ChatConversation(
          id: '1',
          title: 'Chat dengan Customer Service',
          lastMessage: 'Terima kasih telah menghubungi kami. Ada yang bisa kami bantu?',
          lastMessageTime: DateTime.now().subtract(const Duration(minutes: 30)),
          isUnread: true,
          unreadCount: 2,
          adminName: 'CS Gerobaks',
          messages: [
            ChatMessage(
              id: '1',
              message: 'Halo, selamat datang di Gerobaks!',
              timestamp: DateTime.now().subtract(const Duration(hours: 1)),
              isFromUser: false,
              type: MessageType.system,
            ),
            ChatMessage(
              id: '2',
              message: 'Halo, saya ingin bertanya tentang jadwal pengangkutan sampah',
              timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
              isFromUser: true,
            ),
            ChatMessage(
              id: '3',
              message: 'Terima kasih telah menghubungi kami. Ada yang bisa kami bantu?',
              timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
              isFromUser: false,
            ),
          ],
        ),
      ];
      await _saveConversationsToStorage();
    }
    
    _conversationsController.add(_conversations);
  }

  Future<void> _saveConversationsToStorage() async {
    final conversationsData = _conversations.map((conv) => conv.toJson()).toList();
    await _localStorage.saveConversations(conversationsData);
  }

  // Get all conversations
  List<ChatConversation> getConversations() {
    return List.from(_conversations);
  }

  // Get messages for specific conversation
  List<ChatMessage> getMessages(String conversationId) {
    final conversation = _conversations.firstWhere(
      (c) => c.id == conversationId,
      orElse: () => throw Exception('Conversation not found'),
    );
    _currentMessages = List.from(conversation.messages);
    _messagesController.add(_currentMessages);
    return _currentMessages;
  }

  // Send message
  Future<void> sendMessage(String conversationId, String message) async {
    final newMessage = ChatMessage(
      id: _generateId(),
      message: message,
      timestamp: DateTime.now(),
      isFromUser: true,
    );

    // Add to conversation
    final conversationIndex = _conversations.indexWhere((c) => c.id == conversationId);
    if (conversationIndex != -1) {
      final conversation = _conversations[conversationIndex];
      final updatedMessages = List<ChatMessage>.from(conversation.messages)..add(newMessage);
      
      _conversations[conversationIndex] = ChatConversation(
        id: conversation.id,
        title: conversation.title,
        lastMessage: message,
        lastMessageTime: DateTime.now(),
        isUnread: conversation.isUnread,
        unreadCount: conversation.unreadCount,
        adminName: conversation.adminName,
        adminAvatar: conversation.adminAvatar,
        messages: updatedMessages,
      );

      _currentMessages = updatedMessages;
      _messagesController.add(_currentMessages);
      _conversationsController.add(_conversations);
      await _saveConversationsToStorage();

      // Generate AI response using conversation history
      Timer(const Duration(seconds: 1), () {
        _generateAIResponse(conversationId, message);
      });
    }
  }

  // Generate AI response using Gemini
  void _generateAIResponse(String conversationId, String userMessage) async {
    try {
      final geminiService = GeminiAIService();
      
      // Get conversation history for context
      final conversationIndex = _conversations.indexWhere((c) => c.id == conversationId);
      if (conversationIndex == -1) return;
      
      final conversation = _conversations[conversationIndex];
      final recentMessages = conversation.messages
          .where((m) => m.type == MessageType.text)
          .take(10)
          .map((m) => '${m.isFromUser ? "User" : "Admin"}: ${m.message}')
          .toList();
      
      // Generate AI response
      final aiResponse = await geminiService.generateResponse(
        userMessage,
        conversationHistory: recentMessages,
      );
      
      final adminMessage = ChatMessage(
        id: _generateId(),
        message: aiResponse,
        timestamp: DateTime.now(),
        isFromUser: false,
      );

      // Add AI response to conversation
      final updatedMessages = List<ChatMessage>.from(conversation.messages)..add(adminMessage);
      
      _conversations[conversationIndex] = ChatConversation(
        id: conversation.id,
        title: conversation.title,
        lastMessage: aiResponse.length > 50 
            ? '${aiResponse.substring(0, 50)}...' 
            : aiResponse,
        lastMessageTime: DateTime.now(),
        isUnread: true,
        unreadCount: conversation.unreadCount + 1,
        adminName: conversation.adminName,
        adminAvatar: conversation.adminAvatar,
        messages: updatedMessages,
      );

      _currentMessages = updatedMessages;
      _messagesController.add(_currentMessages);
      _conversationsController.add(_conversations);
      await _saveConversationsToStorage();
      
    } catch (e) {
      print('Error generating AI response: $e');
      // Fallback to simple response if AI fails
      _generateFallbackResponse(conversationId);
    }
  }

  // Fallback response if AI service fails
  void _generateFallbackResponse(String conversationId) async {
    final responses = [
      'Terima kasih atas pertanyaannya. Tim customer service Gerobaks siap membantu Anda! 😊',
      'Hai! Saya akan membantu Anda dengan layanan pengelolaan sampah Gerobaks.',
      'Mohon tunggu sebentar, saya akan cek informasinya untuk Anda.',
      'Ada yang bisa saya bantu terkait layanan Gerobaks hari ini?',
      'Tim Gerobaks selalu siap memberikan solusi terbaik untuk pengelolaan sampah Anda.',
    ];

    final randomResponse = responses[Random().nextInt(responses.length)];
    
    final adminMessage = ChatMessage(
      id: _generateId(),
      message: randomResponse,
      timestamp: DateTime.now(),
      isFromUser: false,
    );

    final conversationIndex = _conversations.indexWhere((c) => c.id == conversationId);
    if (conversationIndex != -1) {
      final conversation = _conversations[conversationIndex];
      final updatedMessages = List<ChatMessage>.from(conversation.messages)..add(adminMessage);
      
      _conversations[conversationIndex] = ChatConversation(
        id: conversation.id,
        title: conversation.title,
        lastMessage: randomResponse,
        lastMessageTime: DateTime.now(),
        isUnread: true,
        unreadCount: conversation.unreadCount + 1,
        adminName: conversation.adminName,
        adminAvatar: conversation.adminAvatar,
        messages: updatedMessages,
      );

      _currentMessages = updatedMessages;
      _messagesController.add(_currentMessages);
      _conversationsController.add(_conversations);
      await _saveConversationsToStorage();
    }
  }

  // Mark conversation as read
  Future<void> markAsRead(String conversationId) async {
    final conversationIndex = _conversations.indexWhere((c) => c.id == conversationId);
    if (conversationIndex != -1) {
      final conversation = _conversations[conversationIndex];
      _conversations[conversationIndex] = ChatConversation(
        id: conversation.id,
        title: conversation.title,
        lastMessage: conversation.lastMessage,
        lastMessageTime: conversation.lastMessageTime,
        isUnread: false,
        unreadCount: 0,
        adminName: conversation.adminName,
        adminAvatar: conversation.adminAvatar,
        messages: conversation.messages,
      );
      _conversationsController.add(_conversations);
      await _saveConversationsToStorage();
    }
  }

  // Create new conversation
  Future<String> createNewConversation() async {
    final newConversation = ChatConversation(
      id: _generateId(),
      title: 'Chat Baru',
      lastMessage: 'Chat dimulai',
      lastMessageTime: DateTime.now(),
      isUnread: false,
      unreadCount: 0,
      adminName: 'CS Gerobaks',
      messages: [
        ChatMessage(
          id: _generateId(),
          message: 'Halo! Ada yang bisa kami bantu hari ini?',
          timestamp: DateTime.now(),
          isFromUser: false,
          type: MessageType.system,
        ),
      ],
    );

    _conversations.insert(0, newConversation);
    _conversationsController.add(_conversations);
    await _saveConversationsToStorage();
    return newConversation.id;
  }

  // Get total unread count
  int getTotalUnreadCount() {
    return _conversations.fold(0, (sum, conversation) => sum + conversation.unreadCount);
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  void dispose() {
    _conversationsController.close();
    _messagesController.close();
  }
}
