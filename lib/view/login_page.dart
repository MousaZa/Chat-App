import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mesh_gradient/mesh_gradient.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Login Page'),
      // ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: MeshGradient(
              points: [
                MeshGradientPoint(
                  position: const Offset(
                    0.5,
                    0.5,
                  ),
                  color:  Colors.blue,
                ),
                MeshGradientPoint(
                  position: const Offset(
                    0.7,
                    0.6,
                  ),
                  color: const Color.fromARGB(255, 0, 255, 198),
                ),

              ],
              options: MeshGradientOptions(),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
               color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 100,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[500],
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                const SizedBox(height: 16),
                const Text("Welcome back!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                const SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                ),
                const SizedBox(height: 72),
                Container(
                  width: double.infinity,
                  height: 40,
                  decoration: const BoxDecoration(
                  color: Colors.blue,
                  ),
                  child: MaterialButton(
                    onPressed: ()async {
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text,
                      );
                      Get.offAllNamed('/home');
                    },
                    child: const Text('Login', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                  ),
                ),
                const SizedBox(height: 16),
                MaterialButton(
                  onPressed: () {
                    Get.toNamed('/register');
                  },
                  child: const Text('Create a new account', style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),),

                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
