class UserSession {
  static String _username = '';

  static String _role = '';

  static String get username => _username;

  static void setUsername(String username) {
    _username = username;
  }

  static String get role => _role;

  static void setRole(String role) {
    _role = role;
  }
}