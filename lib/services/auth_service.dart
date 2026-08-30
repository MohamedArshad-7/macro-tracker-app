class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Mock login
  Future<Map<String, dynamic>?> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    
    if (email.isNotEmpty && password.isNotEmpty) {
      return {
        'id': 'user_123',
        'email': email,
        'name': 'User',
      };
    }
    return null;
  }

  // Mock signup
  Future<Map<String, dynamic>?> signUp(String email, String password, String name) async {
    await Future.delayed(const Duration(seconds: 1));
    
    if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
      return {
        'id': 'user_123',
        'email': email,
        'name': name,
      };
    }
    return null;
  }

  // 🎯 Mock Google Sign-In
  Future<Map<String, dynamic>?> signInWithGoogle() async {
    await Future.delayed(const Duration(seconds: 1));
    
    // Simulate successful Google sign-in
    return {
      'id': 'google_user_123',
      'email': 'user@gmail.com',
      'name': 'Google User',
      'photoUrl': 'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
    };
  }

  // Mock logout
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}