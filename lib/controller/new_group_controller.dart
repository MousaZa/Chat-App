import 'package:get/get.dart';

class NewGroupController extends GetxController {

  List selectedUsers = [];

  void selectUser(String uid) {
    if (selectedUsers.contains(uid)) {
      selectedUsers.remove(uid);
    } else {
      selectedUsers.add(uid);
    }
    update();
  }


}