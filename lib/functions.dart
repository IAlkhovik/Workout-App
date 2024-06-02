
import 'package:cloud_firestore/cloud_firestore.dart';

//class of functions used all throughout the app
class Functions {

  //reference to the db document storing users
  static DocumentReference usersDB = FirebaseFirestore.instance.collection('Database').doc("Users");

  //updates the values in a given user's userInfo document
  //or creates a new user if one doesn't exist (and puts in data)
  static uploadUserInfo(String user, Map<String, Object> data){
    usersDB.collection(user).doc("userInfo").set(data);
  }
}