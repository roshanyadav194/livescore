import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ScoringScreen extends StatefulWidget {
  final String matchCode;
  
  const ScoringScreen({super.key, required this.matchCode});

  @override
  State<ScoringScreen> createState() => _ScoringScreenState();
}

class _ScoringScreenState extends State<ScoringScreen> {
  int _runs = 0;
  int _wickets = 0;
  int _balls = 0; 
  int _completedOvers = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _setupRealtimeSubscription();
  }

  // 📡 THIS IS THE MAGIC: It listens to the cloud and updates the screen instantly!
  void _setupRealtimeSubscription() {
    Supabase.instance.client
        .from('matches')
        .stream(primaryKey: ['id'])
        .eq('match_code', widget.matchCode)
        .listen((List> data) {
      if (data.isNotEmpty && mounted) {
        final matchData = data.first;
        setState(() {
          _runs = matchData['runs'] ?? 0;
          _wickets = matchData['wickets'] ?? 0;
          _completedOvers = matchData['completed_overs'] ?? 0;
          _balls = matchData['balls'] ?? 0;
          _isLoading = false; // Hides the loading spinner once connected
        });
      }
    });
  }

  // ☁️ THIS saves the score to the cloud every time you tap a button
  Future<void> _updateCloudScore({required int runsToAdd, required int wicketsToAdd, required int ballsToAdd}) async {
    int newRuns = _runs + runsToAdd;
    int newWickets = _wickets + wicketsToAdd;
    int newBalls = _balls + ballsToAdd;
    int newOvers = _completedOvers;

    if (newBalls == 6) {
      newOvers++;
      newBalls = 0;
    }

    try {
      await Supabase.instance.client
          .from('matches')
          .update({
            'runs': newRuns,
            'wickets': newWickets,
            'completed_overs': newOvers,
            'balls': newBalls,
          })
          .eq('match_code', widget.matchCode);
    } catch (e) {
      debugPrint('Error updating score: $e');
    }
  }

  void _addRuns(int runs) {
    _updateCloudScore(runsToAdd: runs, wicketsToAdd: 0, ballsToAdd: 1);
  }

  void _addWicket() {
    if (_wickets < 10) {
      _updateCloudScore(runsToAdd: 0, wicketsToAdd: 1, ballsToAdd: 1);
    }
  }

  void _addExtra(String type) {
    // Extras add 1 run but do NOT count as a legal ball
    _updateCloudScore(runsToAdd: 1, wicketsToAdd: 0, ballsToAdd: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Match: ${widget.matchCode}', style: const TextStyle(color: Colors.white, fontSize: 16)),
        backgroundColor: const Color(0xFF1C2541),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: Color(0xFF2ECC71)))
        : Column(
        children: [
          // SCOREBOARD SECTION
          Container(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF1C2541), 
              border: Border(bottom: BorderSide(color: Color(0xFF2ECC71), width: 4)),
            ),
            child: Column(
              children: [
                const Text('TOTAL SCORE (LIVE)', style: TextStyle(color: Colors.white54, fontSize: 14, letterSpacing: 2, fontWeight: FontWeight.bold)),
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
