// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:news_app_final/force_update.dart';

import 'package:news_app_final/sign_up_page.dart';

import 'News/News_page.dart';

String text = "Log-In";
String eMail = '', password = '';

class LogInPage extends StatelessWidget {
  const LogInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Log In"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "E-mail",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(
              width: 180,
              child: TextFormField(
                onChanged: (value) {
                  eMail = value;
                },
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: "Enter your E-Mail",
                    labelStyle: TextStyle(
                      fontSize: 16,
                    )),
              ),
            ),
            const Text(
              "Password",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(
              width: 180,
              child: TextFormField(
                onChanged: (value) {
                  password = value;
                },
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: "Enter Password",
                    labelStyle: TextStyle(
                      fontSize: 16,
                    )),
              ),
            ),
            SubmitButton(
              context: context,
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (BuildContext context) => const SignUpPage(),
                    ),
                  );
                },
                child: const Text(
                    "Don't have an account?"))
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class SubmitButton extends StatefulWidget {
  
  BuildContext context;
  SubmitButton({
    Key? key,
    required this.context,
  }) : super(key: key);

  @override
  State<SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {
  @override
  late BuildContext context;
  @override
  void initState() {
    super.initState();
    context = widget.context;
    ForceUpdate(context,mounted).checkAndForceUpdate();
  }
  

  logIn(String eMail, String password, BuildContext context) async {
    try {
      setState(() {
        text = "Logging-in";
      });
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: eMail, password: password);
      DatabaseReference database = FirebaseDatabase.instanceFor(
              app: Firebase.app(),
              databaseURL:
                  "https://news-app-2bcff-default-rtdb.asia-southeast1.firebasedatabase.app")
          .ref("users/${credential.user!.uid}/category");

      final snapshot = await database.get();
      final category = snapshot.value!.toString();
      // ignore: use_build_context_synchronously
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => NewsPage(
            category: category,
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        text = "Log-in";
      });
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(msg: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(msg: 'Wrong password provided for that user.');
      } else if (e.code == "network-request-failed") {
        Fluttertoast.showToast(msg: 'No Internet Connectivity.');
        Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => NewsPage(
            category: category,
          ),
        ),
      );
      } else {
        print(e.code);
      }
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          logIn(eMail, password, context);
        },
        child: Text(text));
  }
}
