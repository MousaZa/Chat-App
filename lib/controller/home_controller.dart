import 'package:chat_app_codsoft/view/widgets/user_card_oto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../view/widgets/user_card.dart';
import 'new_group_controller.dart';

class HomeController extends GetxController {

  getUserConversations() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDocument = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final conversations = userDocument.data()?['conversations'];
      return conversations;
    }
  }

  void newGroupConversationSheet() {
    final NewGroupController controller = Get.put<NewGroupController>(NewGroupController());
    TextEditingController groupNameController = TextEditingController();
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: groupNameController,
              decoration: const InputDecoration(
                labelText: 'Group Name',
              ),
            ),
            const SizedBox(height: 16),
            const Text('Add Members'),
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('email',
                          isNotEqualTo: FirebaseAuth.instance.currentUser!.email)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        final username = snapshot.data?.docs[index]['username'];
                        final uid = snapshot.data?.docs[index].id;
                        return UserCard(
                          username: username,
                          uid: uid ?? '',
                        );
                      },
                    );
                  }),
            ),
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: MaterialButton(
                onPressed: () {

                  newGroupConversation(groupNameController.text, [
                    FirebaseAuth.instance.currentUser?.uid ?? '',
                    ...controller.selectedUsers,
                  ]);
                  Navigator.pop(Get.context!);
                },
                child: const Text('Create Group', style: TextStyle(color: Colors.white),),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void newGroupConversation(String name, List<String> members) {
    FirebaseFirestore.instance.collection("Group-conversations").add({
      'type': 'group',
      'name': name,
      'members': members,
      'admin': members[0],
      'initiatedBy': members[0],
      'initiatedAt': DateTime.now().millisecondsSinceEpoch,
      'lastUpdated': DateTime.now().millisecondsSinceEpoch,
      'lastMessage': null,
    }).then((value) {
      FirebaseFirestore.instance
          .collection("Group-conversations")
          .doc(value.id)
          .collection("messages")
          .add({
        'message': 'Welcome to $name',
        'sender': FirebaseAuth.instance.currentUser?.uid,
        'senderName': FirebaseAuth.instance.currentUser?.displayName,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
      Get.toNamed('/chat', arguments: {
        'uid': value.id,
        'username': name,
      });
    });
  }

 void newOneToOneConversationSheet() {
  Get.bottomSheet(
    Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          FutureBuilder(
            future: getUserConversations(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),

                );
              }
              final existingConversations = (snapshot.data as List<dynamic>).map((item) => item.toString()).toList();
              return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('uid',
                          whereNotIn: existingConversations)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),

                      );
                    }

                    return  snapshot.data!.docs.isEmpty ? const SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('No users found'),
                        ),
                      )
                    ) : ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        final username =
                            snapshot.data?.docs[index]['username'];
                        final uid = snapshot.data?.docs[index].id;
                        return UserCardOto(
                          username: username,
                          uid: uid ?? '',
                          onTap: () {
                            newOneToOneConversation([
                              FirebaseAuth.instance.currentUser?.uid ?? '',
                              uid ?? ''
                            ],name: username);
                            FirebaseFirestore.instance
                                .collection("users")
                                .doc(uid)
                                .update({
                              'conversations': FieldValue.arrayUnion([uid]),
                            });
                            Navigator.pop(Get.context!);
                            Get.toNamed('/otoChat', arguments: {
                              'uid': uid,
                              'name': username,
                            });
                          },
                        );
                      },
                    );
                  });
            },
          )
        ],
      ),
    ),
  );
}

  void newOneToOneConversation(List<String> members, {String? name}) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update({
      'conversations': FieldValue.arrayUnion([members[1]]),
    });
    FirebaseFirestore.instance.collection("Conversations").add({
      'type': 'oneToOne',
      'members': members,
      'membersNames' : [FirebaseAuth.instance.currentUser?.displayName, name],
      'lastUpdated': DateTime.now().millisecondsSinceEpoch,
      'lastMessage': null,

    });
  }

}