import 'package:chat_app_codsoft/view/widgets/user_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OneToOneView extends StatelessWidget {
  const OneToOneView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Chats',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Conversations')
                .where('members',
                arrayContains: FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  final name = snapshot.data?.docs[index]['membersNames'].firstWhere((name) => name != FirebaseAuth.instance.currentUser!.displayName);
                  final id = snapshot.data?.docs[index].id;
                  return name ==
                      FirebaseAuth.instance.currentUser!.displayName
                      ? const SizedBox()
                      : Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 16.0),
                    child: ListTile(
                      leading: UserAvatar(name: name),
                      title: Text(name),
                      onTap: () {
                        Get.toNamed('/otoChat', arguments: {
                          'uid': id,
                          'name': name,
                        });
                      },
                    ),
                  );
                },
              );
            }),
      ],
    );
  }
}
