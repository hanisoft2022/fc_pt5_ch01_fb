// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_flutter_basic/core/common/extension/context.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:velocity_x/velocity_x.dart';

class MyApp extends HookWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final emailTextController = useTextEditingController();
    final passwordTextController = useTextEditingController();
    final storageRef = FirebaseStorage.instance.ref();
    final testImageRef = storageRef.child('image/${DateTime.now().millisecond}.jpg');
    File? file;
    final fbfstdb = FirebaseFirestore.instance;

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextField(
                  decoration: InputDecoration(hintText: '이메일 주소'),
                  controller: emailTextController,
                ).pSymmetric(h: 30, v: 10),
                TextField(
                  decoration: InputDecoration(hintText: '비밀번호'),
                  controller: passwordTextController,
                ).pSymmetric(h: 30, v: 10),
                // firebase auth
                'firebase auth'.text.make(),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: emailTextController.text,
                        password: passwordTextController.text,
                      );
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                      } else if (e.code == 'wrong-password') {}
                    }
                  },
                  child: '로그인'.text.make(),
                ).pSymmetric(v: 10),
                Divider(),
                // firebase storage
                'firebase storage'.text.make(),
                ElevatedButton(
                  onPressed: () async {
                    final FilePickerResult? pickedFile = await FilePicker.platform.pickFiles();
                    if (pickedFile != null) {
                      file = File(pickedFile.files.single.path!);
                    }
                  },
                  child: '파일 선택'.text.make(),
                ).pSymmetric(v: 10),
                ElevatedButton(
                  onPressed: () async {
                    if (file != null) {
                      await testImageRef.putFile(file!);
                    }
                  },
                  child: '파일 전송'.text.make(),
                ).pSymmetric(v: 10),
                Divider(),
                // firebase firestore
                'firebase firestore'.text.make(),
                // CREATE
                ElevatedButton(
                  onPressed: () async {
                    final DocumentReference doc = await fbfstdb.collection('users').add({
                      'email': emailTextController.text,
                      'password': passwordTextController.text,
                    });
                    print(doc.id);
                  },
                  child: 'DATA CREATE (add)'.text.make(),
                ).pSymmetric(v: 10),
                ElevatedButton(
                  onPressed: () async {
                    await fbfstdb.collection('users').doc('test').set({
                      'email': emailTextController.text,
                      'password': passwordTextController.text,
                    });
                  },
                  child: 'DATA CREATE (set)'.text.make(),
                ).pSymmetric(v: 10),
                // READ
                ElevatedButton(
                  onPressed: () async {
                    final doc = await fbfstdb.collection('users').doc('test').get();
                    final data = doc.data() as Map<String, dynamic>;
                    for (var e in data.entries) {
                      print('${e.key} : ${e.value}');
                    }
                  },
                  child: 'DATA READ'.text.make(),
                ).pSymmetric(v: 10),
                // UPDATE
                ElevatedButton(
                  onPressed: () async {
                    await fbfstdb.collection('users').doc('test').update({
                      'email': emailTextController.text,
                      'password': passwordTextController.text,
                      'cute': 'im so cute',
                      'time': Timestamp.now(),
                    });
                  },
                  child: 'DATA UPDATE'.text.make(),
                ).pSymmetric(v: 10),
                // DELETE
                ElevatedButton(
                  onPressed: () async {
                    await fbfstdb.collection('users').doc('test').delete();
                  },
                  child: 'DATA DELETE'.text.make(),
                ).pSymmetric(v: 10),
                Divider(),
                // firebase realtime database
                'firebase realtime database'.text.make(),
                // CREATE
                ElevatedButton(
                  onPressed: () async {
                    await FirebaseDatabase.instance.ref('users/test').set({
                      'email': emailTextController.text,
                      'password': passwordTextController.text,
                    });
                  },
                  child: '데이터 쓰기'.text.make(),
                ).pSymmetric(v: 10),
                ElevatedButton(
                  onPressed: () async {
                    await FirebaseDatabase.instance.ref('messages').push().set({
                      'email': emailTextController.text,
                      'password': passwordTextController.text,
                    });
                  },
                  child: '데이터 푸쉬'.text.make(),
                ).pSymmetric(v: 10),
                // UPDATE
                ElevatedButton(
                  onPressed: () async {
                    await FirebaseDatabase.instance.ref('users/test').update({
                      'email': '${emailTextController.text} ---updated',
                      'password': passwordTextController.text,
                    });
                  },
                  child: '데이터 업데이트'.text.make(),
                ).pSymmetric(v: 10),

                // READ
                ElevatedButton(
                  onPressed: () async {
                    final snapshot = await FirebaseDatabase.instance.ref().get();
                    print('snapshot: ${snapshot.value}');
                  },
                  child: '데이터 읽기'.text.make(),
                ).pSymmetric(v: 10),
                // bottom padding
                Gap(context.bottomPadding),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            try {
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: emailTextController.text,
                password: passwordTextController.text,
              );
            } on FirebaseAuthException catch (e) {
              if (e.code == 'weak-password') {
              } else if (e.code == 'email-already-in-use') {}
            }
          },
        ),
      ),
    );
  }
}
