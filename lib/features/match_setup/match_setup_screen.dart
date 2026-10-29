import 'package:flutter/material.dart';
import 'dart:math';

class MatchSetupScreen extends StatefulWidget {
  const MatchSetupScreen({super.key});

  @override
  State<MatchSetupScreen> createState() => _MatchSetupScreenState();
}

class _MatchSetupScreenState extends State<MatchSetupScreen> {
  final TextEditingController _codeController = TextEditingController();

  // This function generates the random 6-character alphanumeric code
  String generateMatchCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random rnd = Random();
    return String.fromCharCodes(
      Iterable.generate(6, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))),
    );
  }

  void _createNewMatch() {
    String newCode = generateMatchCode();
    // Later, this will save the code to the Supabase database
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Match Created! Your share code is: $newCode', style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF2ECC71), // Cricket Green
      ),
    );
  }

  void _joinMatch() {
    String code = _codeController.text.trim().toUpperCase();
    if (code.length == 6) {
      // Later, this will connect to Supabase Realtime to view the score
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connecting to match $code...'),
          backgroundColor: const Color(0xFF1C2541), // Royal Blue
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
            // SCORER SECTION
            const Text(
              'Start a New Match',
              style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _createNewMatch,
              icon: const Icon(Icons.add_circle_outline, color: Color(0xFF0B132B)),
              label: const Text('Create Match & Get Code', style: TextStyle(color: Color(0xFF0B132B), fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2ECC71), // Cricket Green
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            
            const SizedBox(height: 48),
            
            // DIVIDER
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

            // SPECTATOR SECTION
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
                counterText: '', // Hides the character counter
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _joinMatch,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1C2541), // Royal Blue
                side: const BorderSide(color: Color(0xFF2ECC71), width: 1), // Green outline
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
