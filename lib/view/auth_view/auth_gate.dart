import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_world/view/auth_view/log_in.dart';
import 'package:fashion_world/view/customer_side/customer_home_page.dart';
import 'package:fashion_world/view/deigner_side/designer_home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../theme.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  // Simple cache to avoid repeated Firestore calls
  static final Map<String, String> _roleCache = {};

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        // Handle auth state changes
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return _buildSplashScreen();
        }

        if (authSnapshot.hasError) {
          return _buildErrorScreen();
        }

        // If no user is signed in, show login
        if (!authSnapshot.hasData) {
          return const LogIn();
        }

        // If user is signed in, determine their role
        final user = authSnapshot.data!;
        return _buildUserRoleDependentScreen(user);
      },
    );
  }

  Widget _buildUserRoleDependentScreen(User user) {
    return FutureBuilder<String?>(
      future: _getCachedUserRole(user),
      builder: (context, roleSnapshot) {
        if (roleSnapshot.connectionState == ConnectionState.waiting) {
          return _buildSplashScreen();
        }

        if (roleSnapshot.hasError) {
          return _buildErrorScreen();
        }

        final role = roleSnapshot.data;

        if (role == null) {
          return const LogIn();
        }

        switch (role) {
          case 'Customer':
            return const CustomerHomePage();
          case 'Designer':
            return const DesignerHomePage();
          default:
            return const LogIn();
        }
      },
    );
  }

  /// Get user role with caching to minimize Firestore calls
  Future<String?> _getCachedUserRole(User user) async {
    // Return cached role if available
    if (_roleCache.containsKey(user.uid)) {
      return _roleCache[user.uid];
    }

    try {
      // Fetch user document
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final role = doc.data()?['role'] as String?;
        if (role != null) {
          // Cache the role
          _roleCache[user.uid] = role;
        }
        return role;
      }
    } catch (e) {
      debugPrint('Error fetching user role: $e');
    }

    return null;
  }

  Widget _buildSplashScreen() {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              // Color(0xFF6A11CB),
              // Color(0xFF2575FC),
              TColor.background,
              TColor.background.withOpacity(0.5)
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/img/logo.png',
              height: 100,
              width: 100,
            ),
            const SizedBox(height: 20),
            const Text(
              'Fashion World',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorScreen() {
    return const Scaffold(
      body: Center(
        child: Text(
          'An error occurred. Please restart the app.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
