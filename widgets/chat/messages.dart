import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_complete_guide/widgets/chat/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userId = FirebaseAuth.instance.currentUser.uid;
    /**Major difference in code maxmill uses future builder to resove current user user id
     * new firebase sdk does return a future for the same hence the current userid is fetched bferore everything here
     
      **/
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx, chatSnapShot) {
        if (chatSnapShot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs = chatSnapShot.data.docs;
        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (ctx, index) => MessageBubble(
            chatDocs[index]['text'],
            chatDocs[index]['userId'] == _userId,
            chatDocs[index]['userName'],
            chatDocs[index]['userImage'],

            //key: ValueKey(chatDocs[index].documentID),
          ),
        );
      },
    );
  }
}
