import 'package:chat_app_codsoft/controller/home_controller.dart';
import 'package:chat_app_codsoft/view/groups.dart';
import 'package:chat_app_codsoft/view/one_to_one.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final HomeController homeController = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
            onPressed: () async {
              Get.dialog(AlertDialog(
                title: const Text('Logout'),
                content: const Text('Are you sure you want to logout?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Get.offAllNamed('/login');
                    },
                    child: const Text('Logout'),
                  ),
                ],
              ));
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GroupsView(),
              OneToOneView()
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        openButtonBuilder: RotateFloatingActionButtonBuilder(
          backgroundColor: Colors.blue,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        closeButtonBuilder: FloatingActionButtonBuilder(
          size: 56,
          builder: (BuildContext context, void Function()? onPressed,
              Animation<double> progress) {
            return IconButton(
              onPressed: onPressed,
              icon: const Icon(
                Icons.check_circle_outline,
                size: 40,
              ),
            );
          },
        ),
        children: [
          FloatingActionButton.small(
            backgroundColor: Colors.blue,
            child: const Icon(
              Icons.group_add,
              color: Colors.white,
            ),
            onPressed: () {
              homeController.newGroupConversationSheet();
            },
          ),
          FloatingActionButton.small(
            backgroundColor: Colors.blue,
            child: const Icon(
              Icons.chat,
              color: Colors.white,
            ),
            onPressed: () {
              homeController.newOneToOneConversationSheet();
            },
          ),
        ],
      ),
    );
  }
}
