import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class Conversation with ChangeNotifier {
  final String userId;
  final String fullName;

  Conversation(this.userId, this.fullName);

  Future<void> addMessageToFirestore(
      String messageText, String senderID, String conversationID) async {
    DateTime now = DateTime.now();
    Map<String, dynamic> messageData = {
      'dateTime': now,
      'senderID': senderID,
      'text': messageText
    };
    await Firestore.instance
        .collection('conversations/' + conversationID + '/messages')
        .add(messageData);
  }
}

class Message {
  final String id;
  final String senderID;
  final String text;
  final DateTime dateTime;

  Message({
    @required this.id,
    @required this.senderID,
    @required this.text,
    @required this.dateTime,
  });
}

class Contact {
  final String id;
  final String fullName;

  Contact({
    @required this.id,
    @required this.fullName,
  });
}
