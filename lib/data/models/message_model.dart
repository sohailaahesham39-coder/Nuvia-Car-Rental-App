class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final String chatId;
  final String content;
  final DateTime timestamp;
  final MessageStatus status;
  final MessageType type;
  final List<MessageAttachment>? attachments;
  final String? relatedEntityId; // Can reference a booking, car, etc.
  final String? relatedEntityType; // 'booking', 'car', etc.

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.chatId,
    required this.content,
    required this.timestamp,
    required this.status,
    required this.type,
    this.attachments,
    this.relatedEntityId,
    this.relatedEntityType,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      chatId: json['chatId'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
      status: MessageStatus.values.firstWhere(
            (e) => e.toString() == 'MessageStatus.${json['status']}',
        orElse: () => MessageStatus.sent,
      ),
      type: MessageType.values.firstWhere(
            (e) => e.toString() == 'MessageType.${json['type']}',
        orElse: () => MessageType.text,
      ),
      attachments: json['attachments'] != null
          ? (json['attachments'] as List)
          .map((attachment) => MessageAttachment.fromJson(attachment))
          .toList()
          : null,
      relatedEntityId: json['relatedEntityId'],
      relatedEntityType: json['relatedEntityType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'chatId': chatId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'status': status.toString().split('.').last,
      'type': type.toString().split('.').last,
      'attachments': attachments?.map((attachment) => attachment.toJson()).toList(),
      'relatedEntityId': relatedEntityId,
      'relatedEntityType': relatedEntityType,
    };
  }

  bool get isDelivered => status == MessageStatus.delivered || status == MessageStatus.read;
  bool get isRead => status == MessageStatus.read;
  bool get isSent => status == MessageStatus.sent;
  bool get isPending => status == MessageStatus.pending;
  bool get isFailed => status == MessageStatus.failed;

  Message copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? chatId,
    String? content,
    DateTime? timestamp,
    MessageStatus? status,
    MessageType? type,
    List<MessageAttachment>? attachments,
    String? relatedEntityId,
    String? relatedEntityType,
  }) {
    return Message(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      chatId: chatId ?? this.chatId,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      type: type ?? this.type,
      attachments: attachments ?? this.attachments,
      relatedEntityId: relatedEntityId ?? this.relatedEntityId,
      relatedEntityType: relatedEntityType ?? this.relatedEntityType,
    );
  }
}

enum MessageStatus {
  pending,
  sent,
  delivered,
  read,
  failed,
}

enum MessageType {
  text,
  image,
  video,
  audio,
  document,
  location,
  contact,
  custom,
}

class MessageAttachment {
  final String id;
  final String url;
  final String type; // 'image', 'video', 'audio', 'document'
  final String? name;
  final int? size;
  final String? thumbnailUrl;
  final Map<String, dynamic>? metadata;

  MessageAttachment({
    required this.id,
    required this.url,
    required this.type,
    this.name,
    this.size,
    this.thumbnailUrl,
    this.metadata,
  });

  factory MessageAttachment.fromJson(Map<String, dynamic> json) {
    return MessageAttachment(
      id: json['id'],
      url: json['url'],
      type: json['type'],
      name: json['name'],
      size: json['size'],
      thumbnailUrl: json['thumbnailUrl'],
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'type': type,
      'name': name,
      'size': size,
      'thumbnailUrl': thumbnailUrl,
      'metadata': metadata,
    };
  }
}

class Chat {
  final String id;
  final List<String> participantIds;
  final DateTime createdAt;
  final DateTime lastMessageAt;
  final Message? lastMessage;
  final String? name; // For group chats
  final String? imageUrl; // For group chats
  final bool isGroupChat;
  final Map<String, dynamic>? metadata;
  final Map<String, UnreadCount>? unreadCounts;

  Chat({
    required this.id,
    required this.participantIds,
    required this.createdAt,
    required this.lastMessageAt,
    this.lastMessage,
    this.name,
    this.imageUrl,
    required this.isGroupChat,
    this.metadata,
    this.unreadCounts,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'],
      participantIds: List<String>.from(json['participantIds']),
      createdAt: DateTime.parse(json['createdAt']),
      lastMessageAt: DateTime.parse(json['lastMessageAt']),
      lastMessage: json['lastMessage'] != null
          ? Message.fromJson(json['lastMessage'])
          : null,
      name: json['name'],
      imageUrl: json['imageUrl'],
      isGroupChat: json['isGroupChat'] ?? false,
      metadata: json['metadata'],
      unreadCounts: json['unreadCounts'] != null
          ? Map<String, UnreadCount>.from(
        json['unreadCounts'].map(
              (key, value) => MapEntry(key, UnreadCount.fromJson(value)),
        ),
      )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'participantIds': participantIds,
      'createdAt': createdAt.toIso8601String(),
      'lastMessageAt': lastMessageAt.toIso8601String(),
      'lastMessage': lastMessage?.toJson(),
      'name': name,
      'imageUrl': imageUrl,
      'isGroupChat': isGroupChat,
      'metadata': metadata,
      'unreadCounts': unreadCounts?.map(
            (key, value) => MapEntry(key, value.toJson()),
      ),
    };
  }

  String getOtherParticipantId(String currentUserId) {
    return participantIds.firstWhere(
          (id) => id != currentUserId,
      orElse: () => '', // Return empty string if not found
    );
  }
}

class UnreadCount {
  final int count;
  final DateTime lastReadAt;

  UnreadCount({
    required this.count,
    required this.lastReadAt,
  });

  factory UnreadCount.fromJson(Map<String, dynamic> json) {
    return UnreadCount(
      count: json['count'],
      lastReadAt: DateTime.parse(json['lastReadAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'lastReadAt': lastReadAt.toIso8601String(),
    };
  }
}