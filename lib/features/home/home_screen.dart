import 'package:flutter/material.dart';
import '../match_setup/match_setup_screen.dart';
import '../teams/create_team_screen.dart';
import '../tournaments/tournament_hub_screen.dart';
import '../players/add_player_screen.dart'; // <--- We imported your new Player screen!

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LiveScore Dashboard', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        automaticallyImplyLeading: false, 
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        // THIS allows the screen to scroll if the phone is small
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Welcome to the Field!',
                style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'What would you like to do today?',
                style: TextStyle(color: Colors.white54, fontSize: 16),
              ),
              const SizedBox(height: 32),

              // MATCH ACTION CARD
              _buildActionCard(
                context,
                title: 'Play a Match',
                subtitle: 'Score a new game or join as spectator',
                icon: Icons.sports_cricket,
                color: const Color(0xFF2ECC71), 
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MatchSetupScreen()),
                  );
                },
              ),
              
              const SizedBox(height: 16),

              // TEAM ACTION CARD
              _buildActionCard(
                context,
                title: 'Manage Teams',
                subtitle: 'Create a new local squad',
                icon: Icons.shield,
                color: const Color(0xFF3A506B), 
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CreateTeamScreen()),
                  );
                },
              ),

              const SizedBox(height: 16),

              // NEW ADD PLAYER CARD
              _buildActionCard(
                context,
                title: 'Add Players',
                subtitle: 'Build your team rosters',
                icon: Icons.person_add,
                color: Colors.cyan, // Cyan accent for players!
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddPlayerScreen()),
                  );
                },
              ),

              const SizedBox(height: 16),

              // TOURNAMENT CARD
              _buildActionCard(
                context,
                title: 'Tournament Hub',
                subtitle: 'View league standings & NRR',
                icon: Icons.emoji_events,
                color: Colors.orangeAccent, 
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TournamentHubScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, {required String title, required String subtitle, required IconData icon, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1C2541),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.5), width: 2),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: color.withOpacity(0.2), shape: BoxShape.circle),
              child: Icon(icon, size: 32, color: color),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
          ],
        ),
      ),
    );
  }
}
