// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_flutter_basic/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:velocity_x/velocity_x.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends HookWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final emailTextController = useTextEditingController();
    final passwordTextController = useTextEditingController();

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(hintText: '이메일 주소'),
              controller: emailTextController,
            ).p(10),
            TextField(
              decoration: InputDecoration(hintText: '비밀번호'),
              controller: passwordTextController,
            ).p(10),
            ElevatedButton(
              onPressed: () async {
                try {
                  print('login tapped');
                  final credential = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                        email: emailTextController.text,
                        password: passwordTextController.text,
                      );
                  print('login success');
                  print('----------------------');
                  print(credential.toString());
                  print('----------------------');
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    print('등록된 이메일 주소 아님.');
                  } else if (e.code == 'wrong-password') {
                    print('비번 잘못됨.');
                  }
                }
              },
              child: Text('로그인'),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            try {
              print('fab tapped');
              final credential = await FirebaseAuth.instance
                  .createUserWithEmailAndPassword(
                    email: emailTextController.text,
                    password: passwordTextController.text,
                  );
              print(credential);
              print('user created');
            } on FirebaseAuthException catch (e) {
              if (e.code == 'weak-password') {
                print('password too weak');
              } else if (e.code == 'email-already-in-use') {
                print('email already in use');
              }
            }
          },
        ),
      ),
    );
  }
}
