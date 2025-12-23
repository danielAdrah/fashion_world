import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Cache to store user roles to avoid repeated Firestore calls
  final Map<String, String> _userRoleCache = {};

  /// Get user role with caching to improve performance
  Future<String?> getUserRole(User user) async {
    // Check cache first
    if (_userRoleCache.containsKey(user.uid)) {
      return _userRoleCache[user.uid];
    }

    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();

      if (doc.exists) {
        final role = doc.get('role') as String?;
        if (role != null) {
          // Cache the role for future use
          _userRoleCache[user.uid] = role;
        }
        return role;
      }
    } catch (e) {
      debugPrint('Error fetching user role: $e');
    }

    return null;
  }

  /// Clear user role cache (useful when user logs out)
  void clearCache() {
    _userRoleCache.clear();
  }
}
