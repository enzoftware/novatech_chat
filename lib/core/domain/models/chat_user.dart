import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// Represents a user in the chat application
class ChatUser extends Equatable {
  /// Creates a new [ChatUser] instance
  const ChatUser({
    required this.id,
    required this.displayName,
    required this.email,
    this.photoUrl,
    this.lastSeen,
    this.isOnline = false,
  });

  /// Creates a [ChatUser] from a Firestore document
  factory ChatUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return ChatUser(
      id: doc.id,
      displayName: data['displayName'] as String? ?? 'Unknown User',
      email: data['email'] as String? ?? '',
      photoUrl: data['photoUrl'] as String?,
      lastSeen: (data['lastSeen'] as Timestamp?)?.toDate(),
      isOnline: data['isOnline'] as bool? ?? false,
    );
  }

  /// The unique identifier of the user
  final String id;

  /// The display name of the user
  final String displayName;

  /// The email address of the user
  final String email;

  /// The URL of the user's profile photo
  final String? photoUrl;

  /// The last time the user was seen online
  final DateTime? lastSeen;

  /// Whether the user is currently online
  final bool isOnline;

  /// Converts the [ChatUser] to a Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'displayName': displayName,
      'email': email,
      'photoUrl': photoUrl,
      'lastSeen': lastSeen != null ? Timestamp.fromDate(lastSeen!) : null,
      'isOnline': isOnline,
      // Add a searchable lowercase version of the name for queries
      'searchName': displayName.toLowerCase(),
    };
  }

  /// Creates a copy of this [ChatUser] with the given fields replaced
  ChatUser copyWith({
    String? id,
    String? displayName,
    String? email,
    String? photoUrl,
    DateTime? lastSeen,
    bool? isOnline,
  }) {
    return ChatUser(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      lastSeen: lastSeen ?? this.lastSeen,
      isOnline: isOnline ?? this.isOnline,
    );
  }

  @override
  List<Object?> get props => [
        id,
        displayName,
        email,
        photoUrl,
        lastSeen,
        isOnline,
      ];
}
