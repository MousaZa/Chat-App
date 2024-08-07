import 'package:chat_app_codsoft/view/group_chat_page.dart';
import 'package:chat_app_codsoft/view/login_page.dart';
import 'package:chat_app_codsoft/view/oto_chat_page.dart';
import 'package:chat_app_codsoft/view/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';

import 'firebase_options.dart';
import 'view/home_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/register', page: () => RegisterPage()),
        GetPage(name: '/home', page: () => HomePage()),
        GetPage(name: '/groupChat', page: () => const GroupChatPage()),
        GetPage(name: '/otoChat', page: () => const OneToOneChatPage())
      ],
        home: FirebaseAuth.instance.currentUser == null ? LoginPage() : HomePage(),
    );
  }
}
