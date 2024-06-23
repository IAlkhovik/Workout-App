import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});
  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = ""; //variable for inputted email
  String _password = ""; //vairable for inputted password

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
              ), //input field for email
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                onChanged: (input) => setState(() => _password = input!),
                //validator: (input) => input == null ? 'Invalid Name' : null,
              ), //input field for password
              MaterialButton(onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CreateNewAccountPage(title: "")),
                  );
              },
              child: Container(child:const Text("Create a New Account"))), //button that sends to "create account" page
              MaterialButton(onPressed: () async {
                int errorCode = await loginUser(_email, _password);
                if (errorCode != 0){
                  showDialog(context: context, builder: (context) {return showLoginError(errorCode);});
                } else {
                  showDialog(context: context, builder: (context) {
                    return AlertDialog(
                      title: const Text("Success"),
                      content: const Text("You have been logged in."),
                      actions: <Widget>[
                        TextButton(
                          child: const Text("Continue",
                            style: TextStyle(color: Colors.black, fontSize: 15.0)),
                          onPressed: () {
                            Navigator.pop(context);}
                          ),
                      ]);
                  });
                }
              },
              child: Container(child:const Text("Sign In"))) //button that signs-in user
          ],
        ),
      ),
    );
  }

  //logs in a user or returns an error message
  Future<int> loginUser(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      ); //attempts login
    } on FirebaseAuthException catch (e) {
        if (e.code == 'invalid-email'){
        //print('Please make sure you input a valid email.');
        return 1; //checks if inputted email is actually an email
      } 
    } catch (e) {
      print(e);
      return 3;
    }
    User? user = FirebaseAuth.instance.currentUser;
    if(user != null){ //checks if there is a signed-in user (without specifying incorrect email or password - for security)
      //print("Account Logged-In");
      return 0;
    } else {
      //print("Login Failed");
      return 2;
    }
  }

  AlertDialog showLoginError(int errorCode){
    const String titleText = 'Error'; //title of the alert box
    String contentText = ''; //descriptive error text of the alert box
    if (errorCode == 1){
      contentText = 'Please make sure you input a valid email.';
    } else if (errorCode == 2) {
      contentText = 'An incorrect username or password was inputted.';
    } else {
      contentText = "An unknown error has occured. Please check everything and try again.";
    } //reads error code and changes error text based on what is outputted

    //creats an alert with the given error message
    return AlertDialog(
        title: const Text(titleText),
        content: Text(contentText),
        actions: <Widget>[
          TextButton(
            child: const Text("Close",
              style: TextStyle(color: Colors.black, fontSize: 15.0)),
            onPressed: () {
              Navigator.pop(context);}
            ),
        ]);
  }
}

class CreateNewAccountPage extends StatefulWidget {
  const CreateNewAccountPage({super.key, required this.title});
  final String title;

  @override
  State<CreateNewAccountPage> createState() => _CreateNewAccountPageState();
}

class _CreateNewAccountPageState extends State<CreateNewAccountPage> {
  String _email = ""; //variable for inputted email
  String _password = ""; //variable for inputted password

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
              ), //input field for email
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                onChanged: (input) => setState(() => _password = input!),
                //validator: (input) => input == null ? 'Invalid Name' : null,
              ), //input field for password
              MaterialButton(onPressed: () async {
                int errorCode = await createUser(_email, _password); //error code for creating an account
                if (errorCode != 0){
                  showDialog(context: context, builder: (context) {return showCreationError(errorCode);});
                } //if it fails show error alert box
              },
              child: Container(child:const Text("Register"))) //button that creates a new account
          ],
        ),
      ),
    );
  }

  //creates a user (if possible) or outputs an error code
  Future<int> createUser(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ); //attempts to create a new user with the given credentials
      //print("Account Created");
      return 0;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        //print('The account already exists for that email.');
        return 1;//checks if the given email already has an associated account (returns code if fails)
      } else if (e.code == 'invalid-email'){
        //print('Please make sure you input a valid email.');
        return 2;  //checks if inputted email is actually an email (returns code if fails)
      } else if (e.code == 'weak-password'){
        //print('The password should be atleast 6 characters long.');
        return 3; //checks if given password passes Firebase requirement (returns code if fails)
      }
    } catch (e) {
      //print(e);
      return 4;
    }
    //print("Never Reached");
    return 5;
  }

  //creates an alertbox that shows a given error message
  AlertDialog showCreationError(int errorCode){
    const String titleText = 'Error'; //title of the alert box
    String contentText = ''; //descriptive error text of the alert box
    if (errorCode == 1){
      contentText = 'An account already exists for this email.';
    } else if (errorCode == 2) {
      contentText = 'Please make sure you inputted a valid email address.';
    } else if (errorCode == 3){
      contentText = 'The password should be atleast 6 characters long.';
    }
    else {
      contentText = "An unknown error has occured. Please check everything and try again.";
    } //reads error code and changes error text based on what is outputted

    //creats an alert with the given error message
    return AlertDialog(
        title: const Text(titleText),
        content: Text(contentText),
        actions: <Widget>[
          TextButton(
            child: const Text("Close",
              style: TextStyle(color: Colors.black, fontSize: 15.0)),
            onPressed: () {
              Navigator.pop(context);}
            ),
        ]);
  }
}