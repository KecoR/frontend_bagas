import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour_guide_rental/providers/message.dart';
import 'package:tour_guide_rental/widgets/message_item.dart';

class ConversationScreen extends StatefulWidget {
  @override
  _ConversationScreenState createState() => _ConversationScreenState();

  static const routeName = '/conversation';
}

class _ConversationScreenState extends State<ConversationScreen> {
  String _conversationId;
  String _userId;
  TextEditingController _controller = TextEditingController();

  void _sendMessage() async {
    await Provider.of<Conversation>(context).addMessageToFirestore(
      _controller.text,
      _userId,
      _conversationId,
    );
    setState(() {
      _controller.text = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    _conversationId = ModalRoute.of(context).settings.arguments as String;
    _userId = Provider.of<Conversation>(context).userId;
    return Scaffold(
      appBar: AppBar(
        title: Text('Message'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
              stream: Firestore.instance
                  .collection('conversations/${this._conversationId}/messages')
                  .orderBy('dateTime')
                  .snapshots(),
              builder: (context, snapshots) {
                switch (snapshots.connectionState) {
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    return ListView.builder(
                      itemCount: snapshots.data.documents.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot snapshot =
                            snapshots.data.documents[index];
                        if (snapshot['senderID'] == _userId) {
                          return UserMessage(snapshot);
                        } else {
                          return AnotherMessage(snapshot);
                        }
                      },
                    );
                }
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 4 / 5,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Write a message',
                      contentPadding: EdgeInsets.all(15.0),
                      border: InputBorder.none,
                    ),
                    minLines: 1,
                    maxLines: 5,
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                    controller: _controller,
                  ),
                ),
                Expanded(
                  child: MaterialButton(
                    onPressed: _sendMessage,
                    child: Text('Send'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
