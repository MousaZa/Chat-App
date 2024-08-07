import 'package:chat_app_codsoft/controller/new_group_controller.dart';
import 'package:chat_app_codsoft/view/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserCard extends StatelessWidget {
  UserCard({super.key, required this.username, required this.uid});
  final String username;
  final String uid;
  final NewGroupController controller = Get.put<NewGroupController>(NewGroupController());
  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading:UserAvatar(name: username),
      title: Text(username),
      trailing: GetBuilder<NewGroupController>(
        init: NewGroupController(),
        builder: (controller) {
          return controller.selectedUsers.contains(uid)
              ? const Icon(Icons.check)
              : const SizedBox();
        },
      ),
      onTap: (){
        controller.selectUser(uid);
      },
    );
  }
}
