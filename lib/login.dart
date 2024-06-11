import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});
  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                onChanged: (input) => setState(() => _email = input!),
                //validator: (input) => input == null ? 'Invalid Name' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                onChanged: (input) => setState(() => _password = input!),
                //validator: (input) => input == null ? 'Invalid Name' : null,
              ),
              MaterialButton(onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CreateNewAccountPage(title: "")),
                  );

              },
              child: Container(child:const Text("Create a New Account"))),
              MaterialButton(onPressed: () {
                loginUser(_email, _password);
              },
              child: Container(child:const Text("Sign In")))
          ],
        ),
      ),
    );
  }

  void loginUser(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("Account Logged-In");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('There is no account associated with this email.');
      } else if (e.code == 'invalid-email'){
        print('The inputted email is invalid.');
      } else if (e.code == 'wrong-password'){
        print('The password is incorrect.');
      }
    } catch (e) {
      print(e);
    }
      }
}

class CreateNewAccountPage extends StatefulWidget {
  const CreateNewAccountPage({super.key, required this.title});
  final String title;

  @override
  State<CreateNewAccountPage> createState() => _CreateNewAccountPageState();
}

class _CreateNewAccountPageState extends State<CreateNewAccountPage> {
  String _email = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                onChanged: (input) => setState(() => _email = input!),
                //validator: (input) => input == null ? 'Invalid Name' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                onChanged: (input) => setState(() => _password = input!),
                //validator: (input) => input == null ? 'Invalid Name' : null,
              ),
              MaterialButton(onPressed: () {
                createUser(_email, _password);
              },
              child: Container(child:const Text("Register")))
          ],
        ),
      ),
    );
  }

  void createUser(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("Account Created");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      } else if (e.code == 'invalid-email'){
        print('The inputted email is invalid.');
      } else if (e.code == 'weak-password'){
        print('The password should be atleast 6 characters long.');
      }
    } catch (e) {
      print(e);
    }
      }
}