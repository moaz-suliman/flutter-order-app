import 'package:final_project/models/user_model.dart';
import 'package:final_project/services/firebase/auth_services.dart';
import 'package:final_project/services/firebase/user_services.dart';
import 'package:final_project/services/localBase/local_database_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  User? user;
  UserModel? userData;

  Future<bool> login(String email, String password) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      // تحقق من SQLite أولاً
      final savedUid = await DatabaseHelper.instance.getUid();
      if (savedUid != null) {
        print(' Login from SQLite: $savedUid');
        return true;
      }

      //  Firebase إذا ما في uid استخدم 
      final result = await _authService.login(email: email, password: password);
      user = result.user;

      final doc = await _userService.getUser(user!.uid);
      if (doc.exists) {
        userData = UserModel.fromMap(
          user!.uid,
          doc.data() as Map<String, dynamic>,
        );
      }

      await DatabaseHelper.instance.saveUid(user!.uid);
      return true;

    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'network-request-failed':
          errorMessage = 'No internet connection.';
          break;
        case 'invalid-credential':
          errorMessage = 'Incorrect email or password.';
          break;
        default:
          errorMessage = 'Login failed. Please try again.';
      }
      return false;
    } catch (e) {
      errorMessage = 'Something went wrong.';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(String email, String password, String name) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final result = await _authService.register(
        email: email,
        password: password,
      );

      await _userService.createUser(result.user!.uid, {
        "name": name,
        "email": email,
      });

      user = result.user;
      final doc = await _userService.getUser(user!.uid);
      if (doc.exists) {
        userData = UserModel.fromMap(
          user!.uid,
          doc.data() as Map<String, dynamic>,
        );
      } else {
        userData = null;
      }

      //save uid after login
      await DatabaseHelper.instance.saveUid(user!.uid);
      return true;

    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        errorMessage = 'No internet connection.';
      } else {
        errorMessage = e.message;
      }
      return false;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshUser() async {
    if (user == null) return;
    try {
      final doc = await _userService.getUser(user!.uid);
      if (doc.exists) {
        userData = UserModel.fromMap(
          user!.uid,
          doc.data() as Map<String, dynamic>,
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error refreshing user: $e");
    }
  }

  //uid الخروج اليدوي فقط يحذف 
  Future<void> signOut() async {
    try {
      await _authService.logout();
      await DatabaseHelper.instance.deleteUid(); 
      user = null;
      userData = null;
      notifyListeners();
    } catch (e) {
      debugPrint("Error signing out: $e");
    }
  }

  Stream<User?> get userChanges {
    return _authService.userChanges;
  }
}