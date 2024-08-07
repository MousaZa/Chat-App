import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupsView extends StatelessWidget {
  const GroupsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Groups',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Group-conversations')
                .where('members',
                arrayContains: FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              return snapshot.data!.docs.isEmpty
                  ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('No groups found'),
                ),
              )
                  : ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  final name = snapshot.data?.docs[index]['name'];
                  final id = snapshot.data?.docs[index].id;
                  return name ==
                      FirebaseAuth.instance.currentUser!.displayName
                      ? const SizedBox()
                      : Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 16.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        // radius: 25,
                        backgroundColor: Colors.blue[100],
                        child: const Icon(
                          Icons.group,
                          color: Colors.blueAccent,
                        ),
                      ),
                      title: Text(name),
                      onTap: () {
                        Get.toNamed('/groupChat', arguments: {
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
