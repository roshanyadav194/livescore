import 'package:flutter/material.dart';
import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../scoring/scoring_screen.dart';

class MatchSetupScreen extends StatefulWidget {
  const MatchSetupScreen({super.key});

  @override
  State<MatchSetupScreen> createState() => _MatchSetupScreenState();
}

class _MatchSetupScreenState extends State<MatchSetupScreen> {
  final TextEditingController _codeController = TextEditingController();
  bool _isLoading = false;

  String generateMatchCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random rnd = Random();
    return String.fromCharCodes(
      Iterable.generate(6, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))),
    );
  }

  Future<void> _createNewMatch() async {
    setState(() => _isLoading = true);
    String newCode = generateMatchCode();
    
    try {
      // THIS securely saves the new match code to your Supabase database
      await Supabase.instance.client.from('matches').insert({
        'match_code': newCode,
      });

      if (mounted) {
        // Move the app to the Scoring Screen when cloud save is successful
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScoringScreen(matchCode: newCode),
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error starting match: $error'),
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

  void _joinMatch() async {
    String code = _codeController.text.trim().toUpperCase();
    if (code.length == 6) {
      // Right now, this just opens the screen. We will add a database check in the next step!
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScoringScreen(matchCode: code),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 6-character code.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LiveScore', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Start a New Match',
              style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _createNewMatch,
              icon: _isLoading 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Color(0xFF0B132B), strokeWidth: 2))
                  : const Icon(Icons.add_circle_outline, color: Color(0xFF0B132B)),
              label: Text(_isLoading ? 'Starting...' : 'Create Match & Get Code', style: const TextStyle(color: Color(0xFF0B132B), fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2ECC71),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            
            const SizedBox(height: 48),
            
            Row(
              children: const [
                Expanded(child: Divider(color: Colors.white24, thickness: 1)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text('OR', style: TextStyle(color: Colors.white54)),
                ),
                Expanded(child: Divider(color: Colors.white24, thickness: 1)),
              ],
            ),
            
            const SizedBox(height: 48),

            const Text(
              'Join as a Spectator',
              style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _codeController,
              textCapitalization: TextCapitalization.characters,
              maxLength: 6,
              style: const TextStyle(color: Colors.white, fontSize: 24, letterSpacing: 8),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'ENTER CODE',
                hintStyle: const TextStyle(color: Colors.white24, letterSpacing: 2, fontSize: 16),
                filled: true,
                fillColor: const Color(0xFF1C2541),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                counterText: '',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _joinMatch,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1C2541),
                side: const BorderSide(color: Color(0xFF2ECC71), width: 1),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Watch Live Score', style: TextStyle(color: Color(0xFF2ECC71), fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
