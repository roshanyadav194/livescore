import 'package:flutter/material.dart';

class ScoringScreen extends StatefulWidget {
  final String matchCode;
  
  const ScoringScreen({super.key, required this.matchCode});

  @override
  State<ScoringScreen> createState() => _ScoringScreenState();
}

class _ScoringScreenState extends State<ScoringScreen> {
  // Local state for the scoreboard
  int _runs = 0;
  int _wickets = 0;
  int _balls = 0; // Total legal deliveries in the current over
  int _completedOvers = 0;

  // Function to handle scoring runs
  void _addRuns(int runs) {
    setState(() {
      _runs += runs;
      _balls++;
      if (_balls == 6) {
        _completedOvers++;
        _balls = 0;
      }
    });
  }

  // Function to handle a wicket
  void _addWicket() {
    if (_wickets < 10) {
      setState(() {
        _wickets++;
        _balls++;
        if (_balls == 6) {
          _completedOvers++;
          _balls = 0;
        }
      });
    }
  }

  // Function to handle extras (Wide / No Ball)
  void _addExtra(String type) {
    setState(() {
      _runs++; // Extras add 1 run to the total, but do NOT count as a legal ball
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Match: ${widget.matchCode}', style: const TextStyle(color: Colors.white, fontSize: 16)),
        backgroundColor: const Color(0xFF1C2541),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // SCOREBOARD SECTION
          Container(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF1C2541), // Royal Blue
              border: Border(bottom: BorderSide(color: Color(0xFF2ECC71), width: 4)), // Green accent line
            ),
            child: Column(
              children: [
                const Text('TOTAL SCORE', style: TextStyle(color: Colors.white54, fontSize: 14, letterSpacing: 2)),
                const SizedBox(height: 8),
                Text(
                  '$_runs - $_wickets',
                  style: const TextStyle(color: Colors.white, fontSize: 64, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Overs: $_completedOvers.$_balls',
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
          ),
          
          const Spacer(),

          // SCORING KEYPAD SECTION
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildScoreButton('0', Colors.white24, () => _addRuns(0)),
                    _buildScoreButton('1', const Color(0xFF3A506B), () => _addRuns(1)),
                    _buildScoreButton('2', const Color(0xFF3A506B), () => _addRuns(2)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildScoreButton('3', const Color(0xFF3A506B), () => _addRuns(3)),
                    _buildScoreButton('4', const Color(0xFF2ECC71), () => _addRuns(4), textColor: const Color(0xFF0B132B)),
                    _buildScoreButton('6', const Color(0xFF2ECC71), () => _addRuns(6), textColor: const Color(0xFF0B132B)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildScoreButton('Wide', Colors.orange, () => _addExtra('Wide'), isWide: true),
                    _buildScoreButton('No Ball', Colors.orange, () => _addExtra('NoBall'), isWide: true),
                    _buildScoreButton('OUT', Colors.redAccent, _addWicket, isWide: true),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // A helper widget to create those big, easy-to-tap circular/oval buttons
  Widget _buildScoreButton(String label, Color bgColor, VoidCallback onTap, {bool isWide = false, Color textColor = Colors.white}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isWide ? 100 : 80,
        height: 80,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(isWide ? 20 : 40),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4, offset: const Offset(0, 4)),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(color: textColor, fontSize: isWide ? 18 : 28, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
