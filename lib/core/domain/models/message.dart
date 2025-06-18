import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  Message({
    required this.senderId,
    required this.text,
    required this.timestamp,
    required this.read,
  });

  factory Message.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return Message(
      senderId: data['senderId'] as String,
      text: data['text'] as String,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      read: data['read'] as bool? ?? false,
    );
  }
  final String senderId;
  final String text;
  final DateTime timestamp;
  final bool read;

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'text': text,
      'timestamp': timestamp,
      'read': read,
    };
  }
}
