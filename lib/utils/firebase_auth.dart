import 'package:auth_database_cart/models/our_user.dart';
import 'package:auth_database_cart/utils/database_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String name = "";
  String contact = "";
  String profession = "";

  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  Future loginUser(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      return 'valid';
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  void setDataforUser(String name, String contact, String profession) {
    this.name = name;
    this.contact = contact;
    this.profession = profession;
  }

  Future signUpUser(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      if (user != null) {
        await DatabaseService(user.uid)
            .updateUserData(name, contact, profession);
      }
      return user;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return null;
    }
  }

  Future logout() async {
    try {
      return await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return null;
    }
  }
}
