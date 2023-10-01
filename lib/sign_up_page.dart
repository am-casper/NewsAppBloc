// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'News/news_page.dart';
import 'log_in_page.dart';

List<String> categories = [
  "business",
  "entertainment",
  "general",
  "health",
  "science",
  "sports",
  "technology"
];
String category = categories.elementAt(0);
late String eMail, password, cnfrmPass;
String text = "Sign-Up";

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Sign Up"),
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
                    labelText: "Enter your Password",
                    labelStyle: TextStyle(
                      fontSize: 16,
                    )),
              ),
            ),
            const Text(
              "Confirm Password",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(
              width: 180,
              child: TextFormField(
                onChanged: (value) {
                  cnfrmPass = value;
                },
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: "Re-Enter the Password",
                    labelStyle: TextStyle(
                      fontSize: 16,
                    )),
              ),
            ),
            const Text(
              "Preferred category",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const DropDownWidget(),
            const SignUpButton(),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) => const LogInPage(),
                  ),
                );
              },
              child: const Text("Already having an Account? Click Here!"),
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpButton extends StatefulWidget {
  const SignUpButton({super.key});

  @override
  State<SignUpButton> createState() => _SignUpButtonState();
}

class _SignUpButtonState extends State<SignUpButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        signUp(eMail, password, cnfrmPass, category, context);
      },
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
        ),
      ),
    );
  }

  signUp(String eMail, String password, String cnfrmPass, String category,
      BuildContext context) async {
    if (password != cnfrmPass) {
      Fluttertoast.showToast(msg: "Passwords doesn't match.");
      return;
    } else {
      try {
        setState(() {
          text = "Signing Up";
        });
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: eMail,
          password: password,
        );
        DatabaseReference database = FirebaseDatabase.instanceFor(
                app: Firebase.app(),
                databaseURL:
                    "https://news-app-2bcff-default-rtdb.asia-southeast1.firebasedatabase.app")
            .ref("users/${credential.user!.uid}");
        await database.set({
          "email": eMail,
          "category": category,
        });
        Fluttertoast.showToast(msg: 'Signing you Up.');
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => NewsPage(
              category: category,
            ),
          ),
        );
      } on FirebaseAuthException catch (e) {
        setState(() {
          text = "Sign Up";
        });
        if (e.code == 'weak-password') {
          Fluttertoast.showToast(msg: 'The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          Fluttertoast.showToast(
              msg: 'The account already exists for that email.');
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
          // print(e);
        }
      }
    }
  }
}

class DropDownWidget extends StatefulWidget {
  const DropDownWidget({super.key});

  @override
  State<DropDownWidget> createState() => _DropDownWidget();
}

class _DropDownWidget extends State<DropDownWidget> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: category,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        setState(() {
          category = value!;
        });
      },
      items: categories.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
