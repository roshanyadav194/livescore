import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../match_setup/match_setup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _signIn() async {
    setState(() => _isLoading = true);
    
    try {
      // Sends a secure login link to the user's email using Supabase
      await Supabase.instance.client.auth.signInWithOtp(
        email: _emailController.text.trim(),
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login link sent! Check your email.', style: TextStyle(color: Colors.black)),
            backgroundColor: Color(0xFF2ECC71),
          ),
        );
        // For testing purposes right now, we will just move directly to the next screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MatchSetupScreen()),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${error.toString()}'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B132B), // Dark Navy Background
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.sports_cricket, size: 80, color: Color(0xFF2ECC71)),
            const SizedBox(height: 24),
            const Text(
              'LiveScore',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Sign in to score local matches',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 48),
            TextField(
              controller: _emailController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter your email address',
                hintStyle: const TextStyle(color: Colors.white38),
                prefixIcon: const Icon(Icons.email_outlined, color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF1C2541), // Royal Blue
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _signIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2ECC71),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _isLoading 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Color(0xFF0B132B), strokeWidth: 2))
                  : const Text('Send Login Link', style: TextStyle(color: Color(0xFF0B132B), fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
