import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  ////////////////////////////////////////////////////////////
  /// INTERNAL: convert phone → email
  ////////////////////////////////////////////////////////////

  static String _phoneToEmail(String phone) {

    // remove spaces and symbols
    phone = phone.replaceAll(RegExp(r'[^0-9]'), '');

    return "$phone@krishi.app";
  }

  ////////////////////////////////////////////////////////////
  /// SIGN UP
  ////////////////////////////////////////////////////////////

  static Future<String?> signup({
    required String phone,
    required String password,
    required String name,
    required String dob,
  }) async {

    try {

      phone = phone.replaceAll(RegExp(r'[^0-9]'), '');

      // VALIDATION
      if (phone.isEmpty || password.isEmpty || name.isEmpty) {
        return "Please fill all fields";
      }

      if (phone.length != 10) {
        return "Phone number must be 10 digits";
      }

      if (password.length < 6) {
        return "Password must be at least 6 characters";
      }

      final email = _phoneToEmail(phone);

      ////////////////////////////////////////////////////////////
      /// CHECK if account exists
      ////////////////////////////////////////////////////////////

      final methods =
          await _auth.fetchSignInMethodsForEmail(email);

      if (methods.isNotEmpty) {
        return "Account already exists. Please login.";
      }

      ////////////////////////////////////////////////////////////
      /// CREATE AUTH USER
      ////////////////////////////////////////////////////////////

      UserCredential userCred =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCred.user!.uid;

      ////////////////////////////////////////////////////////////
      /// SAVE USER DATA TO FIRESTORE
      ////////////////////////////////////////////////////////////

      await _db.collection("users").doc(uid).set({

        "uid": uid,
        "phone": phone,
        "name": name,
        "dob": dob,

        "createdAt": FieldValue.serverTimestamp(),

      });

      return null;

    } on FirebaseAuthException catch (e) {

      if (e.code == 'email-already-in-use') {
        return "Account already exists. Please login.";
      }

      return e.message ?? "Signup failed";

    } catch (e) {

      return "Signup failed. Try again.";

    }

  }

  ////////////////////////////////////////////////////////////
  /// LOGIN
  ////////////////////////////////////////////////////////////

  static Future<String?> login({
    required String phone,
    required String password,
  }) async {

    try {

      phone = phone.replaceAll(RegExp(r'[^0-9]'), '');

      if (phone.length != 10) {
        return "Enter valid phone number";
      }

      final email = _phoneToEmail(phone);

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return null;

    } on FirebaseAuthException catch (e) {

      if (e.code == 'user-not-found') {
        return "Account not found";
      }

      if (e.code == 'wrong-password') {
        return "Incorrect password";
      }

      return e.message ?? "Login failed";

    } catch (e) {

      return "Login failed";

    }

  }

  ////////////////////////////////////////////////////////////
  /// GET CURRENT USER DATA
  ////////////////////////////////////////////////////////////

  static Future<Map<String, dynamic>?> getUser() async {

    try {

      final user = _auth.currentUser;

      if (user == null) {
        print("No logged in user");
        return null;
      }

      print("Fetching UID: ${user.uid}");

      final doc =
          await _db.collection("users")
              .doc(user.uid)
              .get();

      if (!doc.exists) {
        print("User document not found");
        return null;
      }

      print("User data loaded");

      return doc.data();

    } catch (e) {

      print("Error loading user: $e");
      return null;

    }

  }

  ////////////////////////////////////////////////////////////
  /// LOGOUT
  ////////////////////////////////////////////////////////////

  static Future<void> logout() async {

    await _auth.signOut();

  }

  ////////////////////////////////////////////////////////////
  /// CHECK LOGIN STATUS
  ////////////////////////////////////////////////////////////

  static bool isLoggedIn() {

    return _auth.currentUser != null;

  }

}
