import 'package:chat_app_codsoft/view/widgets/message_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupChatPage extends StatelessWidget {
  const GroupChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String uid = args['uid'];
    final String name = args['name'];
    final TextEditingController messageController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Column(
        children: [
          Expanded(
            child:StreamBuilder(
              stream: FirebaseFirestore.instance.collection('Group-conversations').doc(uid).collection('messages').orderBy('timestamp', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (context, index) {
                    final message = snapshot.data?.docs[index]['message'];
                    final sender = snapshot.data?.docs[index]['sender'];
                    final senderUsername = snapshot.data?.docs[index]['senderName'];
                    return MessageWidget(
                      message: message,
                      sender: sender,
                      senderUsername: senderUsername,
                    );
                  },
                );
              }
            ),
          ),
          Container(
            padding:const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Message',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
               FloatingActionButton(
                 onPressed: () {
                   FirebaseFirestore.instance.collection('Group-conversations').doc(uid).collection('messages').add({
                     'message': messageController.text,
                     'sender': FirebaseAuth.instance.currentUser?.uid,
                     'senderName': FirebaseAuth.instance.currentUser?.displayName,
                     'timestamp': FieldValue.serverTimestamp(),
                   }).then((value) => messageController.clear());
                 },
                 backgroundColor: Colors.blue,
                 child: const Icon(Icons.send,color: Colors.white,),
               ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
