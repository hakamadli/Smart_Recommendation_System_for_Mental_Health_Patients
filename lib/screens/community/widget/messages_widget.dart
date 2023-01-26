import 'package:flutter/material.dart';

import '../../../api/chat_firebase_api.dart';
import '../../../data.dart';
import '../../../models/message.dart';
import 'message_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessagesWidget extends StatelessWidget {
  final String uid;

  const MessagesWidget({
    required this.uid,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => StreamBuilder<List<Message>>(
        stream: FirebaseApi.getMessages(uid),
        builder: (context, snapshot) {
          String myId = FirebaseAuth.instance.currentUser!.uid;
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return buildText('Something went wrong try again later');
              } else {
                final messages = snapshot.data;
                return messages!.isEmpty
                    ? buildText('Say hi..')
                    : ListView.builder(
                        physics: BouncingScrollPhysics(),
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];

                          return MessageWidget(
                            message: message,
                            isMe: message.idUser == myId,
                          );
                        },
                      );
              }
          }
        },
      );

  Widget buildText(String text) => Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 18),
        ),
      );
}
