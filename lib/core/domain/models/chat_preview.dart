import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// Represents a chat preview item in the chat list
class ChatPreview extends Equatable {
  /// Creates a new [ChatPreview]
  const ChatPreview({
    required this.id,
    required this.lastMessage,
    required this.lastSenderId,
    required this.participants,
    this.unreadCount = 0,
  });

  /// Creates a [ChatPreview] from a Firestore document
  factory ChatPreview.fromFirestore(DocumentSnapshot doc) {
    try {
      final data = doc.data()! as Map<String, dynamic>;
      return ChatPreview(
        id: doc.id,
        lastSenderId: data['lastSenderId'] as String? ?? '',
        lastMessage: data['lastMessage'] as String? ?? '',
        unreadCount: data['unreadCount'] as int? ?? 0,
        participants: List<String>.from(data['participants'] as List? ?? []),
      );
    } catch (e) {
      throw Exception('Failed to parse ChatPreview from Firestore: $e');
    }
  }

  /// Unique identifier of the chat
  final String id;

  /// The last message in the chat
  final String lastMessage;

  /// Timestamp of the last message
  final String lastSenderId;

  /// List of participant IDs in the chat
  final List<String> participants;

  /// Number of unread messages
  final int unreadCount;

  /// Converts the [ChatPreview] to a Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'lastMessage': lastMessage,
      'unreadCount': unreadCount,
      'lastSenderId': lastSenderId,
      'participants': participants,
    };
  }

  /// Creates a copy of this [ChatPreview] with the given fields replaced
  ChatPreview copyWith({
    String? id,
    String? lastMessage,
    List<String>? participants,
    int? unreadCount,
    String? lastSenderId,
  }) {
    return ChatPreview(
      id: id ?? this.id,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
      lastSenderId: lastSenderId ?? this.lastSenderId,
      participants: participants ?? this.participants,
    );
  }

  @override
  List<Object?> get props => [
        id,
        lastMessage,
        lastSenderId,
        participants,
        unreadCount,
      ];
}
