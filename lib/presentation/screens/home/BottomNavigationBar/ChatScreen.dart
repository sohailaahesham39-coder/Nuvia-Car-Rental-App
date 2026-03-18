import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:async';
import 'dart:ui' as ui;

import '../../../../l10n/AppLocalizations.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _chatAnimationController;
  bool _isChatOpen = false;

  // Active chat contact ID
  String? _activeChatId;

  // Animation for chat slide effect
  late Animation<Offset> _chatSlideAnimation;

  // Voice recording state
  bool _isRecording = false;
  int _recordingDuration = 0;
  Timer? _recordingTimer;

  // Dummy data - replace with real data from your API
  final List<Map<String, dynamic>> _contacts = [
    {
      'id': 'contact1',
      'name': 'Ahmed Hassan',
      'avatar': 'https://i.pinimg.com/564x/bb/9b/87/bb9b87533f9eeff17ec188c339e6f584.jpg',
      'lastMessage': 'When will the car be ready?',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
      'unreadCount': 2,
      'isOnline': true,
      'role': 'Car Owner',
      'booking': 'Toyota Fortuner (ABC 123)',
    },
    {
      'id': 'contact2',
      'name': 'Nuvia Support',
      'avatar': 'https://i.pinimg.com/564x/3d/76/3c/3d763c6a41e5eeefc3f3333b7a792988.jpg',
      'lastMessage': 'How can we assist you today?',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'unreadCount': 0,
      'isOnline': true,
      'role': 'Customer Support',
      'booking': null,
    },
    {
      'id': 'contact3',
      'name': 'Sarah Mohamed',
      'avatar': 'https://i.pinimg.com/564x/fa/65/06/fa65066f1bc363de09a221a92c0c7b58.jpg',
      'lastMessage': 'Your booking is confirmed! I\'ll meet you at the airport.',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'unreadCount': 0,
      'isOnline': false,
      'role': 'Car Owner',
      'booking': 'Mercedes C-Class (XYZ 789)',
    },
    {
      'id': 'ai_bot',
      'name': 'Nuvia AI Bot',
      'avatar': 'https://i.pinimg.com/564x/12/34/56/1234567890abcdef1234567890abcdef.jpg',
      'lastMessage': 'Hello! How can I assist you today?',
      'timestamp': DateTime.now(),
      'unreadCount': 0,
      'isOnline': true,
      'role': 'AI Assistant',
      'booking': null,
    },
  ];

  // Chat messages by contact ID
  final Map<String, List<Map<String, dynamic>>> _messages = {
    'contact1': [
      {
        'id': 'm1',
        'sender': 'contact1',
        'text': 'Hello! I wanted to confirm our meeting time for the car handover.',
        'timestamp': DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
        'status': 'read',
        'type': 'text',
      },
      {
        'id': 'm2',
        'sender': 'user',
        'text': 'Hi Ahmed! Yes, we agreed on 3 PM at the airport, right?',
        'timestamp': DateTime.now().subtract(const Duration(hours: 1, minutes: 25)),
        'status': 'read',
        'type': 'text',
      },
      {
        'id': 'm3',
        'sender': 'contact1',
        'text': 'That\'s correct. I\'ll be there with the Toyota Fortuner.',
        'timestamp': DateTime.now().subtract(const Duration(hours: 1, minutes: 20)),
        'status': 'read',
        'type': 'text',
      },
      {
        'id': 'm4',
        'sender': 'user',
        'voiceNoteDuration': 10,
        'timestamp': DateTime.now().subtract(const Duration(hours: 1, minutes: 15)),
        'status': 'read',
        'type': 'voice',
      },
      {
        'id': 'm5',
        'sender': 'contact1',
        'text': 'Yes, it will be fully fueled and cleaned before handover.',
        'timestamp': DateTime.now().subtract(const Duration(hours: 1)),
        'status': 'read',
        'type': 'text',
      },
      {
        'id': 'm6',
        'sender': 'user',
        'text': 'Perfect! Looking forward to it.',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 55)),
        'status': 'read',
        'type': 'text',
      },
      {
        'id': 'm7',
        'sender': 'contact1',
        'text': 'When will the car be ready?',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
        'status': 'delivered',
        'type': 'text',
      },
    ],
    'contact2': [
      {
        'id': 'm1',
        'sender': 'contact2',
        'text': 'Welcome to Nuvia Support! How can we assist you today?',
        'timestamp': DateTime.now().subtract(const Duration(hours: 3)),
        'status': 'read',
        'type': 'text',
      },
      {
        'id': 'm2',
        'sender': 'user',
        'text': 'Hi, I have a question about cancellation policies.',
        'timestamp': DateTime.now().subtract(const Duration(hours: 2, minutes: 50)),
        'status': 'read',
        'type': 'text',
      },
      {
        'id': 'm3',
        'sender': 'contact2',
        'text': 'Of course! I\'d be happy to help with that. Our cancellation policy allows free cancellation up to 24 hours before pickup. After that, there may be fees depending on the timing.',
        'timestamp': DateTime.now().subtract(const Duration(hours: 2, minutes: 45)),
        'status': 'read',
        'type': 'text',
      },
      {
        'id': 'm4',
        'sender': 'contact2',
        'text': 'Would you like me to explain the specific fees?',
        'timestamp': DateTime.now().subtract(const Duration(hours: 2, minutes: 44)),
        'status': 'read',
        'type': 'text',
      },
      {
        'id': 'm5',
        'sender': 'user',
        'text': 'Yes, please. I may need to change my plans.',
        'timestamp': DateTime.now().subtract(const Duration(hours: 2, minutes: 40)),
        'status': 'read',
        'type': 'text',
      },
      {
        'id': 'm6',
        'sender': 'contact2',
        'text': 'If you cancel between 24 hours and 12 hours before pickup, there\'s a 25% fee. Between 12 hours and 6 hours, it\'s 50%. Less than 6 hours or no-show results in a 100% fee.',
        'timestamp': DateTime.now().subtract(const Duration(hours: 2, minutes: 35)),
        'status': 'read',
        'type': 'text',
      },
      {
        'id': 'm7',
        'sender': 'contact2',
        'text': 'How can we assist you today?',
        'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
        'status': 'read',
        'type': 'text',
      },
    ],
    'contact3': [
      {
        'id': 'm1',
        'sender': 'user',
        'text': 'Hi Sarah, I just made a booking for the Mercedes.',
        'timestamp': DateTime.now().subtract(const Duration(days: 1, hours: 2)),
        'status': 'read',
        'type': 'text',
      },
      {
        'id': 'm2',
        'sender': 'contact3',
        'text': 'Hi there! Yes, I see your booking request.',
        'timestamp': DateTime.now().subtract(const Duration(days: 1, hours: 1, minutes: 55)),
        'status': 'read',
        'type': 'text',
      },
      {
        'id': 'm3',
        'sender': 'contact3',
        'text': 'I\'ve just approved it. Looking forward to meeting you!',
        'timestamp': DateTime.now().subtract(const Duration(days: 1, hours: 1, minutes: 50)),
        'status': 'read',
        'type': 'text',
      },
      {
        'id': 'm4',
        'sender': 'user',
        'text': 'Great! What time should we meet?',
        'timestamp': DateTime.now().subtract(const Duration(days: 1, hours: 1, minutes: 45)),
        'status': 'read',
        'type': 'text',
      },
      {
        'id': 'm5',
        'sender': 'contact3',
        'text': 'How about 2 PM at the airport? I can meet you at the arrivals gate.',
        'timestamp': DateTime.now().subtract(const Duration(days: 1, hours: 1, minutes: 40)),
        'status': 'read',
        'type': 'text',
      },
      {
        'id': 'm6',
        'sender': 'user',
        'text': 'That works perfectly!',
        'timestamp': DateTime.now().subtract(const Duration(days: 1, hours: 1, minutes: 35)),
        'status': 'read',
        'type': 'text',
      },
      {
        'id': 'm7',
        'sender': 'contact3',
        'text': 'Your booking is confirmed! I\'ll meet you at the airport.',
        'timestamp': DateTime.now().subtract(const Duration(days: 1)),
        'status': 'read',
        'type': 'text',
      },
    ],
    'ai_bot': [
      {
        'id': 'm1',
        'sender': 'ai_bot',
        'text': 'Hello! I\'m Nuvia AI Bot. How can I assist you today? You can ask about bookings, cancellations, or car availability.',
        'timestamp': DateTime.now(),
        'status': 'read',
        'type': 'text',
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    if (_contacts.isNotEmpty) {
      _activeChatId = _contacts.first['id'];
    }

    _chatAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _chatSlideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _chatAnimationController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _recordingTimer?.cancel();
    _chatAnimationController.dispose();
    super.dispose();
  }

  void _sendMessage({bool isVoiceNote = false, int? voiceNoteDuration}) {
    if (_activeChatId == null) {
      return;
    }

    // Send voice note if applicable
    if (isVoiceNote && voiceNoteDuration != null) {
      final voiceMessage = {
        'id': 'm${DateTime.now().millisecondsSinceEpoch}',
        'sender': 'user',
        'text': null,
        'voiceNoteDuration': voiceNoteDuration,
        'timestamp': DateTime.now(),
        'status': 'sending',
        'type': 'voice',
      };

      setState(() {
        _messages[_activeChatId]!.add(voiceMessage);
      });
    }

    // Send text message if there's text in the controller
    if (_messageController.text.trim().isNotEmpty) {
      final textMessage = {
        'id': 'm${DateTime.now().millisecondsSinceEpoch + 1}', // Ensure unique ID
        'sender': 'user',
        'text': _messageController.text.trim(),
        'voiceNoteDuration': null,
        'timestamp': DateTime.now(),
        'status': 'sending',
        'type': 'text',
      };

      setState(() {
        _messages[_activeChatId]!.add(textMessage);
        _messageController.clear();
      });
    }

    // Simulate message being sent
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        final messages = _messages[_activeChatId]!;
        for (var i = 0; i < messages.length; i++) {
          if (messages[i]['status'] == 'sending') {
            messages[i]['status'] = 'delivered';
          }
        }
      });

      // AI bot response if the active chat is with the bot
      if (_activeChatId == 'ai_bot') {
        final lastTextMessage = _messages[_activeChatId]!
            .lastWhere((m) => m['type'] == 'text', orElse: () => {});
        if (lastTextMessage.isNotEmpty) {
          _handleAIResponse(lastTextMessage);
        }
      }
    });

    _scrollToBottom();
  }

  void _handleAIResponse(Map<String, dynamic> userMessage) {
    final userText = userMessage['text']?.toString().toLowerCase() ?? '';
    String aiResponse;

    // Simple AI logic based on keywords
    if (userText.contains('booking') || userText.contains('reservation')) {
      aiResponse = 'You can view your bookings under the "Bookings" tab. Would you like to know how to modify or cancel a booking?';
    } else if (userText.contains('cancel') || userText.contains('cancellation')) {
      aiResponse = 'Our cancellation policy allows free cancellation up to 24 hours before pickup. Between 24-12 hours, there\'s a 25% fee; 12-6 hours, 50%; less than 6 hours, 100%. Would you like to proceed with a cancellation?';
    } else if (userText.contains('car') || userText.contains('availability')) {
      aiResponse = 'You can check car availability by searching with your preferred location and dates. Would you like to search for a car now?';
    } else {
      aiResponse = 'I\'m sorry, I didn\'t quite understand that. You can ask about bookings, cancellations, or car availability. How can I assist you?';
    }

    final aiMessage = {
      'id': 'm${DateTime.now().millisecondsSinceEpoch}',
      'sender': 'ai_bot',
      'text': aiResponse,
      'timestamp': DateTime.now(),
      'status': 'delivered',
      'type': 'text',
    };

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages[_activeChatId]!.add(aiMessage);
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _setActiveChat(String contactId) {
    if (_activeChatId == contactId && _isChatOpen) {
      // Close chat if it's already open
      _chatAnimationController.reverse().then((_) {
        setState(() {
          _isChatOpen = false;
        });
      });
    } else {
      // Open chat for new contact
      setState(() {
        _activeChatId = contactId;
        _isChatOpen = true;
        final contact = _contacts.firstWhere((c) => c['id'] == contactId);
        contact['unreadCount'] = 0;
      });
      _chatAnimationController.forward();
      _scrollToBottom();
    }
  }

  void _startRecording() {
    setState(() {
      _isRecording = true;
      _recordingDuration = 0;
    });

    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordingDuration++;
      });
    });
  }

  void _stopRecording() {
    _recordingTimer?.cancel();
    setState(() {
      _isRecording = false;
    });

    // Send the voice note and any accompanying text
    _sendMessage(isVoiceNote: true, voiceNoteDuration: _recordingDuration);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor.withOpacity(0.1),
                    Theme.of(context).primaryColor.withOpacity(0.2),
                  ],
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.chat_bubble_outline,
                color: Theme.of(context).primaryColor,
                size: 20.w,
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              l10n.chat,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.h),
          child: Container(
            height: 1.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Theme.of(context).dividerColor,
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.05),
              Colors.white,
            ],
          ),
        ),
        child: Stack(
          children: [
            Row(
              children: [
                // Contact List
                Expanded(
                  flex: _isChatOpen ? 1 : 2,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20.r),
                        bottomRight: Radius.circular(20.r),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10.r,
                          offset: Offset(5.w, 0),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Search Bar
                        Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 5.r,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: l10n.search,
                                hintStyle: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey.shade600,
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  size: 20.w,
                                  color: Colors.grey.shade600,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    Icons.filter_list,
                                    size: 20.w,
                                    color: Colors.grey.shade600,
                                  ),
                                  onPressed: () {
                                    // Implement filter functionality
                                  },
                                ),
                                filled: true,
                                fillColor: Colors.transparent,
                                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ).animate()
                              .fadeIn(duration: 600.ms)
                              .slideY(begin: -0.2, end: 0),
                        ),

                        // Contact List
                        Expanded(
                          child: ListView.builder(
                            itemCount: _contacts.length,
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            itemBuilder: (context, index) {
                              final contact = _contacts[index];
                              final isActive = _activeChatId == contact['id'] && _isChatOpen;

                              return ContactListTile(
                                contact: contact,
                                isActive: isActive,
                                onTap: () => _setActiveChat(contact['id']),
                              ).animate()
                                  .fadeIn(duration: 600.ms, delay: (index * 100).ms)
                                  .slideX(begin: -0.2, end: 0);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Chat Area
                if (_isChatOpen)
                  Expanded(
                    flex: 3,
                    child: SlideTransition(
                      position: _chatSlideAnimation,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.r),
                            bottomLeft: Radius.circular(20.r),
                          ),
                        ),
                        child: _activeChatId == null
                            ? Center(
                          child: Text(
                            l10n.startSearching,
                            style: TextStyle(fontSize: 16.sp, color: Colors.grey.shade600),
                          ),
                        )
                            : Column(
                          children: [
                            // Chat Header
                            _buildChatHeader(context),

                            // Messages
                            Expanded(
                              child: _buildMessagesList(context),
                            ),

                            // Message Input
                            _buildMessageInput(context),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // Instructions Overlay for new users
            if (!_isChatOpen && _contacts.isNotEmpty)
              Positioned(
                top: 0,
                bottom: 0,
                right: 20.w,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).primaryColor.withOpacity(0.3),
                          blurRadius: 10.r,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.touch_app,
                          color: Colors.white,
                          size: 20.w,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Tap a contact to open chat',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ).animate(
                  onPlay: (controller) => controller.repeat(reverse: true),
                )
                    .shimmer(duration: 1500.ms)
                    .fadeIn(duration: 600.ms)
                    .then() // wait for fade
                    .slideX(begin: 0.2, end: 0, duration: 600.ms),
              ),
          ],
        ),
      ),
      floatingActionButton: _isChatOpen
          ? null
          : FloatingActionButton.extended(
        onPressed: () {
          // Open new chat dialog
        },
        backgroundColor: Theme.of(context).primaryColor,
        icon: const Icon(Icons.add),
        label: const Text('New Chat'),
      ).animate()
          .fadeIn(duration: 600.ms)
          .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
    );
  }

  Widget _buildChatHeader(BuildContext context) {
    if (_activeChatId == null) return const SizedBox.shrink();

    final contact = _contacts.firstWhere((c) => c['id'] == _activeChatId);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.r,
            offset: Offset(0, 5.h),
          ),
        ],
      ),
      child: Row(
        children: [
          // Back/Close Button
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new, size: 20.w),
            onPressed: () {
              _chatAnimationController.reverse().then((_) {
                setState(() {
                  _isChatOpen = false;
                });
              });
            },
          ),

          SizedBox(width: 8.w),

          // Contact Avatar
          Stack(
            children: [
              Hero(
                tag: 'avatar_${contact['id']}',
                child: Container(
                  width: 45.w,
                  height: 45.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10.r,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: contact['avatar'],
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey.shade200,
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey.shade200,
                        child: Icon(Icons.person, size: 24.w, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),
              if (contact['isOnline'])
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 14.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2.w,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: 12.w),

          // Contact Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact['name'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  contact['isOnline'] ? 'Online' : 'Offline',
                  style: TextStyle(
                    color: contact['isOnline'] ? Colors.green : Colors.grey.shade600,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Actions
          IconButton(
            icon: Icon(Icons.phone, size: 24.w, color: Theme.of(context).primaryColor),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Calling ${contact['name']}...'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert, size: 24.w, color: Colors.grey.shade600),
            onPressed: () {
              _showChatOptionsMenu(context, contact);
            },
          ),
        ],
      ),
    ).animate()
        .fadeIn(duration: 600.ms)
        .slideY(begin: -0.2, end: 0);
  }

  Widget _buildMessagesList(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_activeChatId == null) return const SizedBox.shrink();

    final messages = _messages[_activeChatId] ?? [];

    if (messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chat_bubble_outline,
                size: 48.w,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              l10n.noMessagesYet,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              l10n.startTheConversation,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ).animate()
          .fadeIn(duration: 600.ms)
          .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1));
    }

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isUser = message['sender'] == 'user';
        final nextMessage = index < messages.length - 1 ? messages[index + 1] : null;

        bool showTimestamp = true;
        if (nextMessage != null) {
          final nextTime = nextMessage['timestamp'] as DateTime;
          final currentTime = message['timestamp'] as DateTime;
          if (nextTime.difference(currentTime).inMinutes < 5 &&
              nextMessage['sender'] == message['sender']) {
            showTimestamp = false;
          }
        }

        bool showAvatar = true;
        if (nextMessage != null && nextMessage['sender'] == message['sender']) {
          showAvatar = false;
        }

        return Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 8.w), // Reduced vertical padding
          child: MessageBubble(
            message: message,
            isUser: isUser,
            showTimestamp: showTimestamp,
            showAvatar: showAvatar,
            contact: _contacts.firstWhere((c) => c['id'] == _activeChatId),
          ),
        ).animate()
            .fadeIn(duration: 300.ms, delay: (index * 50).ms)
            .slideY(begin: 0.2, end: 0);
      },
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ClipRect(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withOpacity(0.9),
                Colors.white.withOpacity(0.95),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 15.r,
                offset: Offset(0, -4.h),
                spreadRadius: 2.r,
              ),
            ],
            border: Border(
              top: BorderSide(
                color: Colors.grey.withOpacity(0.2),
                width: 1.h,
              ),
            ),
          ),
          child: SafeArea(
            child: Row(
              children: [
                // Attachment button
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.grey.shade200,
                        Colors.grey.shade100,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8.r,
                        offset: Offset(0, 2.h),
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.7),
                        blurRadius: 10.r,
                        offset: Offset(0, -3.h),
                        spreadRadius: -2.r,
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        // Implement attachment picker
                      },
                      borderRadius: BorderRadius.circular(14.r),
                      child: Icon(
                        Icons.add_circle_outline,
                        size: 20.w,
                        color: Theme.of(context).primaryColor.withOpacity(0.8),
                      ),
                    ),
                  ),
                ).animate()
                    .fadeIn(duration: 400.ms)
                    .slideX(begin: -0.2, end: 0),

                SizedBox(width: 8.w),

                // Message input field
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.grey.shade50,
                          Colors.white,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 8.r,
                          offset: Offset(0, 3.h),
                          spreadRadius: 1.r,
                        ),
                        BoxShadow(
                          color: Colors.white.withOpacity(0.8),
                          blurRadius: 5.r,
                          offset: Offset(0, -2.h),
                          spreadRadius: -1.r,
                        ),
                      ],
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            decoration: InputDecoration(
                              hintText: l10n.typeAMessage,
                              hintStyle: TextStyle(
                                fontSize: 15.sp,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w400,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 14.h,
                              ),
                            ),
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => _sendMessage(),
                            maxLines: null,
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: Colors.black.withOpacity(0.8),
                            ),
                          ),
                        ),
                        if (_isRecording)
                          Container(
                            margin: EdgeInsets.only(right: 8.w),
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.graphic_eq, color: Colors.red, size: 16.w)
                                    .animate(
                                  onPlay: (controller) => controller.repeat(reverse: true),
                                )
                                    .scale(
                                  begin: const Offset(0.8, 0.8),
                                  end: const Offset(1.2, 1.2),
                                  duration: 800.ms,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  '${_recordingDuration}s',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ).animate()
                              .fadeIn(duration: 300.ms)
                              .slideX(begin: 0.2, end: 0),
                      ],
                    ),
                  ),
                ).animate()
                    .fadeIn(duration: 500.ms)
                    .slideY(begin: 0.2, end: 0),

                SizedBox(width: 8.w),

                // Button row
                Row(
                  children: [
                    if (_messageController.text.isNotEmpty)
                      Container(
                        width: 40.w,
                        height: 40.h,
                        margin: EdgeInsets.only(right: 4.w),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Theme.of(context).primaryColor.withOpacity(0.9),
                              Theme.of(context).primaryColor,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).primaryColor.withOpacity(0.4),
                              blurRadius: 12.r,
                              offset: Offset(0, 4.h),
                              spreadRadius: -2.r,
                            ),
                            BoxShadow(
                              color: Colors.white.withOpacity(0.5),
                              blurRadius: 4.r,
                              offset: Offset(0, -1.h),
                              spreadRadius: -1.r,
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _sendMessage,
                            borderRadius: BorderRadius.circular(16.r),
                            child: Center(
                              child: Icon(
                                Icons.send_rounded,
                                size: 18.w,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ).animate()
                          .fadeIn(duration: 300.ms)
                          .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),

                    Container(
                      width: 40.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: _isRecording
                              ? [
                            Colors.red.shade400,
                            Colors.red.shade600,
                          ]
                              : _messageController.text.isEmpty
                              ? [
                            Theme.of(context).primaryColor.withOpacity(0.9),
                            Theme.of(context).primaryColor,
                          ]
                              : [
                            Colors.grey.shade600,
                            Colors.grey.shade800,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: (_isRecording
                                ? Colors.red
                                : _messageController.text.isEmpty
                                ? Theme.of(context).primaryColor
                                : Colors.grey.shade700)
                                .withOpacity(0.4),
                            blurRadius: 12.r,
                            offset: Offset(0, 4.h),
                            spreadRadius: -2.r,
                          ),
                          BoxShadow(
                            color: Colors.white.withOpacity(0.5),
                            blurRadius: 4.r,
                            offset: Offset(0, -1.h),
                            spreadRadius: -1.r,
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _isRecording ? _stopRecording : _startRecording,
                          borderRadius: BorderRadius.circular(16.r),
                          child: Center(
                            child: Icon(
                              _isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                              size: 20.w,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ).animate()
                        .fadeIn(duration: 400.ms)
                        .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showChatOptionsMenu(BuildContext context, Map<String, dynamic> contact) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40.w,
                  height: 4.h,
                  margin: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.delete, size: 24.w, color: Colors.red),
                  title: Text(
                    l10n.deleteConversation,
                    style: TextStyle(fontSize: 16.sp, color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    // Implement delete conversation logic
                  },
                ),
                if (contact['booking'] != null)
                  ListTile(
                    leading: Icon(Icons.directions_car, size: 24.w, color: Colors.grey.shade600),
                    title: Text(
                      l10n.viewBooking,
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    subtitle: Text(
                      contact['booking'],
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      // Navigate to booking details
                    },
                  ),
                ListTile(
                  leading: Icon(Icons.block, size: 24.w, color: Colors.grey.shade600),
                  title: Text(
                    l10n.blockContact,
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    // Show block confirmation dialog
                  },
                ),
                ListTile(
                  leading: Icon(Icons.flag, size: 24.w, color: Colors.grey.shade600),
                  title: Text(
                    l10n.reportIssue,
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to report issue screen
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class WaveformPainter extends CustomPainter {
  final bool isPlaying;
  final Color color;
  final double animationValue;

  WaveformPainter({
    required this.isPlaying,
    required this.color,
    this.animationValue = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    const waveCount = 25;
    final waveWidth = size.width / waveCount;

    for (var i = 0; i < waveCount; i++) {
      final x = i * waveWidth + waveWidth / 2;
      final baseHeightFactor = isPlaying
          ? (i % 4 == 0 ? 0.8 : (i % 3 == 0 ? 0.4 : 0.6))
          : 0.3;
      final animatedHeightFactor = isPlaying
          ? baseHeightFactor * (1 + 0.2 * sin(animationValue + i * 0.5))
          : baseHeightFactor;
      final y1 = size.height * (1 - animatedHeightFactor) / 2;
      final y2 = size.height - y1;

      canvas.drawLine(Offset(x, y1), Offset(x, y2), paint);
    }
  }

  @override
  bool shouldRepaint(covariant WaveformPainter oldDelegate) {
    return oldDelegate.isPlaying != isPlaying ||
        oldDelegate.color != color ||
        oldDelegate.animationValue != animationValue;
  }
}

class MessageBubble extends StatelessWidget {
  final Map<String, dynamic> message;
  final bool isUser;
  final bool showTimestamp;
  final bool showAvatar;
  final Map<String, dynamic> contact;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isUser,
    required this.showTimestamp,
    required this.showAvatar,
    required this.contact,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final timestamp = message['timestamp'] as DateTime;
    final messageType = message['type'] as String;

    return Row(
      mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!isUser && showAvatar) _buildAvatar(context, isArabic),
        if (!isUser && !showAvatar) SizedBox(width: 48.w),

        Flexible(
          child: GestureDetector(
            onLongPress: () => _showMessageOptions(context),
            child: Container(
              constraints: BoxConstraints(maxWidth: 0.75.sw),
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isUser ? Theme.of(context).primaryColor : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(18.r).copyWith(
                  bottomRight: isUser && !isArabic ? Radius.circular(4.r) : null,
                  bottomLeft: !isUser && !isArabic ? Radius.circular(4.r) : null,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 4.r,
                    offset: Offset(0, 2.h),
                  ),
                ],
              ),
              child: messageType == 'voice'
                  ? _buildVoiceNoteBubble(context, message)
                  : _buildTextMessage(context, timestamp),
            ),
          ),
        ),

        if (isUser && showAvatar) _buildUserAvatar(context, isArabic),
        if (isUser && !showAvatar) SizedBox(width: 48.w),
      ],
    );
  }

  Widget _buildAvatar(BuildContext context, bool isArabic) {
    return Padding(
      padding: EdgeInsets.only(right: isArabic ? 0 : 8.w, left: isArabic ? 8.w : 0),
      child: CircleAvatar(
        radius: 16.r,
        backgroundImage: CachedNetworkImageProvider(contact['avatar'] ?? ''),
        backgroundColor: Colors.grey.shade200,
        child: contact['avatar'] == null
            ? Icon(Icons.person, size: 16.w, color: Colors.grey)
            : null,
      ),
    );
  }

  Widget _buildUserAvatar(BuildContext context, bool isArabic) {
    return Padding(
      padding: EdgeInsets.only(left: isArabic ? 0 : 8.w, right: isArabic ? 8.w : 0),
      child: CircleAvatar(
        radius: 16.r,
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
        child: Icon(
          Icons.person,
          size: 16.w,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildTextMessage(BuildContext context, DateTime timestamp) {
    return Column(
      crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          message['text'],
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
            fontSize: 15.sp,
            height: 1.3,
          ),
        ),
        if (showTimestamp) ...[
          SizedBox(height: 4.h),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Text(
                DateFormat('HH:mm').format(timestamp),
                style: TextStyle(
                  fontSize: 11.sp,
                  color: isUser ? Colors.white70 : Colors.grey.shade600,
                ),
              ),
              if (isUser) ...[
                SizedBox(width: 4.w),
                Icon(
                  message['status'] == 'sending'
                      ? Icons.access_time
                      : message['status'] == 'delivered'
                      ? Icons.done
                      : Icons.done_all,
                  size: 14.w,
                  color: Colors.white70,
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildVoiceNoteBubble(BuildContext context, Map<String, dynamic> message) {
    final duration = message['voiceNoteDuration'] as int;

    return _VoiceNotePlayer(
      duration: duration,
      isUser: isUser,
      status: message['status'],
      showTimestamp: showTimestamp,
    );
  }

  void _showMessageOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.copy, size: 20.w),
              title: Text('Copy', style: TextStyle(fontSize: 14.sp)),
              onTap: () {
                // Implement copy
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.reply, size: 20.w),
              title: Text('Reply', style: TextStyle(fontSize: 14.sp)),
              onTap: () {
                // Implement reply
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, size: 20.w),
              title: Text('Delete', style: TextStyle(fontSize: 14.sp)),
              onTap: () {
                // Implement delete
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _VoiceNotePlayer extends StatefulWidget {
  final int duration;
  final bool isUser;
  final String? status;
  final bool showTimestamp;

  const _VoiceNotePlayer({
    required this.duration,
    required this.isUser,
    this.status,
    required this.showTimestamp,
  });

  @override
  __VoiceNotePlayerState createState() => __VoiceNotePlayerState();
}

class __VoiceNotePlayerState extends State<_VoiceNotePlayer>
    with SingleTickerProviderStateMixin {
  bool _isPlaying = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    )..addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
          icon: Icon(
            _isPlaying ? Icons.pause : Icons.play_arrow,
            color: widget.isUser ? Colors.white : Colors.black87,
            size: 10.w,
          ),
          onPressed: () {
            setState(() {
              _isPlaying = !_isPlaying;
              _isPlaying ? _controller.repeat() : _controller.stop();
            });
            // Implement audio playback
          },
        ),
        SizedBox(
          width: 100.w,
          height: 24.h,
          child: CustomPaint(
            painter: WaveformPainter(
              isPlaying: _isPlaying,
              color: widget.isUser ? Colors.white : Colors.black87,
              animationValue: _controller.value * 2 * 3.14159,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          '${widget.duration}s',
          style: TextStyle(
            color: widget.isUser ? Colors.white : Colors.black87,
            fontSize: 12.sp,
          ),
        ),
        if (widget.showTimestamp && widget.isUser) ...[
          SizedBox(width: 8.w),
          Icon(
            widget.status == 'sending'
                ? Icons.access_time
                : widget.status == 'delivered'
                ? Icons.done
                : Icons.done_all,
            size: 14.w,
            color: Colors.white70,
          ),
        ],
      ],
    );
  }
}

class ContactListTile extends StatelessWidget {
  final Map<String, dynamic> contact;
  final bool isActive;
  final VoidCallback onTap;
  final Function(DismissDirection)? onSwipe;

  const ContactListTile({
    super.key,
    required this.contact,
    required this.isActive,
    required this.onTap,
    this.onSwipe,
  });

  @override
  Widget build(BuildContext context) {
    final timestamp = contact['timestamp'] as DateTime?;
    String timeString = '';
    if (timestamp != null) {
      final now = DateTime.now();
      timeString = now.difference(timestamp).inDays > 0
          ? DateFormat('dd/MM').format(timestamp)
          : DateFormat('HH:mm').format(timestamp);
    }

    return Dismissible(
      key: Key(contact['id'].toString()),
      direction: onSwipe != null ? DismissDirection.endToStart : DismissDirection.none,
      onDismissed: onSwipe,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 16.w),
        child: Icon(Icons.delete, color: Colors.white, size: 24.w),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: isActive ? Theme.of(context).primaryColor.withOpacity(0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12.r),
            child: Padding(
              padding: EdgeInsets.all(50.w),
              child: Row(
                children: [
                  _buildAvatar(context),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                contact['name'] ?? 'Unknown',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.sp,
                                  color: Theme.of(context).colorScheme.onBackground,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (contact['role'] == 'AI Assistant') ...[
                              SizedBox(width: 6.w),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Text(
                                  'AI',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          contact['lastMessage'] ?? '',
                          style: TextStyle(
                            color: (contact['unreadCount'] ?? 0) > 0
                                ? Theme.of(context).colorScheme.onBackground
                                : Colors.grey.shade600,
                            fontWeight: (contact['unreadCount'] ?? 0) > 0
                                ? FontWeight.w500
                                : FontWeight.normal,
                            fontSize: 13.sp,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        timeString,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: (contact['unreadCount'] ?? 0) > 0
                              ? Theme.of(context).primaryColor
                              : Colors.grey.shade600,
                        ),
                      ),
                      if ((contact['unreadCount'] ?? 0) > 0) ...[
                        SizedBox(height: 6.h),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Text(
                            '${contact['unreadCount']}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 48.w,
          height: 48.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 6.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: contact['avatar'] ?? '',
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey.shade200,
                child: Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2.w,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey.shade200,
                child: Icon(
                  Icons.person,
                  size: 24.w,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ),
        ),
        if (contact['isOnline'] == true)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 12.w,
              height: 12.h,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.w),
              ),
            ),
          ),
      ],
    );
  }
}

class MessageInput extends StatefulWidget {
  final Function(String) onSendMessage;
  final Function() onStartRecording;
  final Function() onStopRecording;

  const MessageInput({
    super.key,
    required this.onSendMessage,
    required this.onStartRecording,
    required this.onStopRecording,
  });

  @override
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final _messageController = TextEditingController();
  bool _isRecording = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      widget.onSendMessage(_messageController.text.trim());
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8.r,
            offset: Offset(0, -2.h),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            _buildAttachmentButton(),
            SizedBox(width: 8.w),
            Expanded(child: _buildTextInput()),
            SizedBox(width: 8.w),
            _buildVoiceButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentButton() {
    return Container(
      width: 40.w,
      height: 40.h,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Implement attachment picker
          },
          borderRadius: BorderRadius.circular(20.r),
          child: Icon(
            Icons.add,
            size: 22.w,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildTextInput() {
    return Container(
      height: 44.h,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message',
                hintStyle: TextStyle(
                  fontSize: 15.sp,
                  color: Theme.of(context).hintColor,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
                ),
              ),
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          if (_isRecording)
            Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: Text(
                'Recording...',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildVoiceButton() {
    return Container(
      width: 40.w,
      height: 40.h,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _isRecording = !_isRecording;
            });
            _isRecording ? widget.onStartRecording() : widget.onStopRecording();
          },
          borderRadius: BorderRadius.circular(20.r),
          child: Icon(
            _isRecording ? Icons.stop : Icons.mic,
            size: 22.w,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}