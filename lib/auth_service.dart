import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Fungsi untuk Registrasi
  Future<User?> registerWithEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Fungsi untuk Login
  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Fungsi untuk Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Stream untuk memantau status otentikasi
  Stream<User?> get user => _auth.authStateChanges();
}
