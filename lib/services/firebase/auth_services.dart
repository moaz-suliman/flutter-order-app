import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  Future<UserCredential> register({required String email, required String password}) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> login({required String email, required String password}) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> logout() async => await _auth.signOut();

  User? get currentUser {
    return _auth.currentUser;
  }// get current user

  Stream<User?> get authStateChanges {
    return _auth.authStateChanges();
  }// stream of user


  Stream<User?> get userChanges => _auth.authStateChanges();
}