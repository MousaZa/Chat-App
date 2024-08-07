import 'package:chat_app_codsoft/view/widgets/user_avatar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageWidget extends StatefulWidget {
  const MessageWidget({super.key, required this.message,required this.sender, required this.senderUsername});
  final String message;
  final String sender ;
  final String senderUsername;

  @override
  State<MessageWidget> createState() => _MessageWidgetState();

}
bool showUsername = false;
class _MessageWidgetState extends State<MessageWidget> {
  @override
  Widget build(BuildContext context) {
    final isMe = widget.sender == FirebaseAuth.instance.currentUser!.uid;

    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Visibility(
                visible: !(isMe),
                child: GestureDetector(
                  child: UserAvatar(name: widget.senderUsername),
                  onTap: () {
                    setState(() {
                      showUsername = !showUsername;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isMe ? Colors.blue: Colors.grey[300],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  widget.message,
                  style: TextStyle(
                    color: isMe ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ],
          ),
          Visibility(
            visible: showUsername,
            child: Text(widget.senderUsername),
          ),
        ],
      ),
    );
  }
}
