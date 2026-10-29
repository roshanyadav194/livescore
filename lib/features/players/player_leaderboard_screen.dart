import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PlayerLeaderboardScreen extends StatefulWidget {
  const PlayerLeaderboardScreen({super.key});

  @override
  State<PlayerLeaderboardScreen> createState() => _PlayerLeaderboardScreenState();
}

class _PlayerLeaderboardScreenState extends State<PlayerLeaderboardScreen> {
  List> _topBatters = [];
  List> _topBowlers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLeaderboards();
  }

  Future<void> _fetchLeaderboards() async {
    try {
      // 1. Fetch top 10 batters by total runs
      final battersData = await Supabase.instance.client
          .from('players')
          .select()
          .order('total_runs', ascending: false)
          .limit(10);
          
      // 2. Fetch top 10 bowlers by total wickets
      final bowlersData = await Supabase.instance.client
          .from('players')
          .select()
          .order('total_wickets', ascending: false)
          .limit(10);
          
      if (mounted) {
        setState(() {
          _topBatters = List>.from(battersData);
          _topBowlers = List>.from(bowlersData);
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching leaderboards: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Player Statistics', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          bottom: const TabBar(
            indicatorColor: Color(0xFF2ECC71),
            labelColor: Color(0xFF2ECC71),
            unselectedLabelColor: Colors.white54,
            tabs: [
              Tab(text: 'Most Runs', icon: Icon(Icons.sports_cricket)),
              Tab(text: 'Most Wickets', icon: Icon(Icons.sports_baseball)),
            ],
          ),
        ),
        body: _isLoading 
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF2ECC71)))
            : TabBarView(
                children: [
                  // ORANGE CAP: BATTERS LIST
                  _buildList(_topBatters, 'total_runs', 'Runs', Colors.orangeAccent),
                  // PURPLE CAP: BOWLERS LIST
                  _buildList(_topBowlers, 'total_wickets', 'Wickets', Colors.purpleAccent),
                ],
              ),
      ),
    );
  }

  Widget _buildList(List> players, String statKey, String statLabel, Color highlightColor) {
    if (players.isEmpty) {
      return const Center(child: Text('No player data yet.', style: TextStyle(color: Colors.white54, fontSize: 16)));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: players.length,
      itemBuilder: (context, index) {
        final player = players[index];
        return Card(
          color: const Color(0xFF1C2541),
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: highlightColor.withOpacity(0.2),
              child: Text('#${index + 1}', style: TextStyle(color: highlightColor, fontWeight: FontWeight.bold)),
            ),
            title: Text(player['name'] ?? 'Unknown', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            subtitle: Text(player['role'] ?? 'Player', style: const TextStyle(color: Colors.white54)),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(player[statKey].toString(), style: TextStyle(color: highlightColor, fontSize: 22, fontWeight: FontWeight.bold)),
                Text(statLabel, style: const TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
        );
      },
    );
  }
}
