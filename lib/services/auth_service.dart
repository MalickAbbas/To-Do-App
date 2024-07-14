import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class AuthService with ChangeNotifier {
  late Box _authBox;

  AuthService() {
    _init();
  }

  Future<void> _init() async {
    _authBox = await Hive.openBox('authBox');
  }

  void signUp(String email, String password) {
    _authBox.put(email, password);
  }

  bool signIn(String email, String password) {
    final storedPassword = _authBox.get(email);
    return storedPassword == password;
  }

  void signOut() {
    // Implement sign out logic if needed
  }
}
