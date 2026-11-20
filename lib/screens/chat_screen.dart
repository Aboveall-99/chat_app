import 'package:flutter/material.dart';
import 'package:chat_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


final _fireStore = FirebaseFirestore.instance;
User? loggedInUser;

class ChatScreen extends StatefulWidget {
  static const id = "chat_screen";
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {


  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  String? messageText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }


  void getCurrentUser(){
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser?.email);
      }
    }
    catch(e){
      print(e);
    }
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      print(loggedInUser?.email);
                      messageTextController.clear();
                      _fireStore.collection("messages").add({
                        "text":messageText,
                        "sender":loggedInUser!.email,
                        "timestamp":FieldValue.serverTimestamp()
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class MessagesStream extends StatelessWidget {
  const MessagesStream({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(stream: _fireStore.collection("messages").orderBy("timestamp").snapshots(), builder: (context, snapshot){
      if(snapshot.hasData){
        final messages = snapshot.data!.docs.reversed;
        List<MessageBubble> messageBubbles = [];

        for(var message in messages){
          final messageData = message.data();
          final messageText = messageData["text"];
          final messageSender = messageData["sender"];
          final currentUser = loggedInUser?.email;
          
          
          final messageBubble = MessageBubble(sender: messageSender, text: messageText, isMe: currentUser == messageSender,);
          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
            children: messageBubbles,
          ),
        );
      }
      else{
        return Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.lightBlueAccent,
          ),
        );
      }
    });
  }
}


class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, this.sender, this.text, required this.isMe});

  final String? sender;
  final String? text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          Text(sender!,
          style: TextStyle(
            fontSize: 12,
            color: Colors.black54
          ),
          ),
          Material(
            borderRadius: BorderRadius.only(
              topLeft: isMe == false? Radius.circular(0):Radius.circular(30),
              bottomRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              topRight: isMe == false? Radius.circular(30):Radius.circular(0),
            ),
            elevation: 5,
              color:isMe? Colors.lightBlueAccent: Colors.white,
              child:
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                child: Text("$text",
                style: TextStyle(
                  fontSize: 15,
                  color: isMe? Colors.white:Colors.black54,
                ),
                ),
              )
          ),
        ],
      ),
    );
  }
}

