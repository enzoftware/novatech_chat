import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// Represents a chat preview item in the chat list
class ChatPreview extends Equatable {
  /// Creates a new [ChatPreview]
  const ChatPreview({
    required this.id,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.participantsIds,
    required this.participantsNames,
    this.unreadCount = 0,
    this.lastMessageSenderId,
    this.lastMessageType = 'text',
    this.groupName,
    this.groupAvatar,
    this.isGroup = false,
  });

  /// Creates a [ChatPreview] from a Firestore document
  factory ChatPreview.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return ChatPreview(
      id: doc.id,
      lastMessage: data['lastMessage'] as String? ?? '',
      lastMessageTime: (data['lastMessageTime'] as Timestamp).toDate(),
      participantsIds: List<String>.from(data['participantsIds'] as List),
      participantsNames: List<String>.from(data['participantsNames'] as List),
      unreadCount: data['unreadCount'] as int? ?? 0,
      lastMessageSenderId: data['lastMessageSenderId'] as String?,
      lastMessageType: data['lastMessageType'] as String? ?? 'text',
      groupName: data['groupName'] as String?,
      groupAvatar: data['groupAvatar'] as String?,
      isGroup: data['isGroup'] as bool? ?? false,
    );
  }

  /// Unique identifier of the chat
  final String id;

  /// The last message in the chat
  final String lastMessage;

  /// Timestamp of the last message
  final DateTime lastMessageTime;

  /// List of participant IDs in the chat
  final List<String> participantsIds;

  /// List of participant names in the chat
  final List<String> participantsNames;

  /// Number of unread messages
  final int unreadCount;

  /// ID of the user who sent the last message
  final String? lastMessageSenderId;

  /// Type of the last message (text, image, video, etc.)
  final String lastMessageType;

  /// Name of the group (if it's a group chat)
  final String? groupName;

  /// Avatar URL of the group (if it's a group chat)
  final String? groupAvatar;

  /// Whether this is a group chat
  final bool isGroup;

  /// Converts the [ChatPreview] to a Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'lastMessage': lastMessage,
      'lastMessageTime': Timestamp.fromDate(lastMessageTime),
      'participantsIds': participantsIds,
      'participantsNames': participantsNames,
      'unreadCount': unreadCount,
      'lastMessageSenderId': lastMessageSenderId,
      'lastMessageType': lastMessageType,
      'groupName': groupName,
      'groupAvatar': groupAvatar,
      'isGroup': isGroup,
    };
  }

  /// Creates a copy of this [ChatPreview] with the given fields replaced
  ChatPreview copyWith({
    String? id,
    String? lastMessage,
    DateTime? lastMessageTime,
    List<String>? participantsIds,
    List<String>? participantsNames,
    int? unreadCount,
    String? lastMessageSenderId,
    String? lastMessageType,
    String? groupName,
    String? groupAvatar,
    bool? isGroup,
  }) {
    return ChatPreview(
      id: id ?? this.id,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      participantsIds: participantsIds ?? this.participantsIds,
      participantsNames: participantsNames ?? this.participantsNames,
      unreadCount: unreadCount ?? this.unreadCount,
      lastMessageSenderId: lastMessageSenderId ?? this.lastMessageSenderId,
      lastMessageType: lastMessageType ?? this.lastMessageType,
      groupName: groupName ?? this.groupName,
      groupAvatar: groupAvatar ?? this.groupAvatar,
      isGroup: isGroup ?? this.isGroup,
    );
  }

  @override
  List<Object?> get props => [
        id,
        lastMessage,
        lastMessageTime,
        participantsIds,
        participantsNames,
        unreadCount,
        lastMessageSenderId,
        lastMessageType,
        groupName,
        groupAvatar,
        isGroup,
      ];
}
