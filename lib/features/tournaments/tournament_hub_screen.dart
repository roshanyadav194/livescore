import 'package:flutter/material.dart';

class TournamentHubScreen extends StatefulWidget {
  const TournamentHubScreen({super.key});

  @override
  State<TournamentHubScreen> createState() => _TournamentHubScreenState();
}

class _TournamentHubScreenState extends State<TournamentHubScreen> {
  // Placeholder data. In the next step, we will pull this live from Supabase!
  final List> _standings = [
    {'rank': 1, 'team': 'Royal Challengers', 'p': 5, 'w': 4, 'l': 1, 'pts': 8, 'nrr': '+1.250'},
    {'rank': 2, 'team': 'Pratappur Strikers', 'p': 5, 'w': 3, 'l': 2, 'pts': 6, 'nrr': '+0.850'},
    {'rank': 3, 'team': 'SSD Convent XI', 'p': 5, 'w': 3, 'l': 2, 'pts': 6, 'nrr': '-0.120'},
    {'rank': 4, 'team': 'Haripur Heroes', 'p': 5, 'w': 0, 'l': 5, 'pts': 0, 'nrr': '-1.980'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tournament Hub', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'League Standings',
              style: TextStyle(color: Color(0xFF2ECC71), fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            
            // LEAGUE TABLE
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1C2541), // Royal Blue
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 24,
                    headingRowColor: MaterialStateProperty.all(const Color(0xFF0B132B)), // Dark Navy Header
                    headingTextStyle: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
                    dataTextStyle: const TextStyle(color: Colors.white, fontSize: 16),
                    columns: const [
                      DataColumn(label: Text('#')),
                      DataColumn(label: Text('Team')),
                      DataColumn(label: Text('P'), numeric: true, tooltip: 'Matches Played'),
                      DataColumn(label: Text('Pts'), numeric: true, tooltip: 'Points'),
                      DataColumn(label: Text('NRR'), numeric: true, tooltip: 'Net Run Rate'),
                    ],
                    rows: _standings.map((team) {
                      return DataRow(
                        cells: [
                          DataCell(Text(team['rank'].toString(), style: const TextStyle(color: Colors.white54))),
                          DataCell(Text(team['team'], style: const TextStyle(fontWeight: FontWeight.bold))),
                          DataCell(Text(team['p'].toString())),
                          DataCell(Text(team['pts'].toString(), style: const TextStyle(color: Color(0xFF2ECC71), fontWeight: FontWeight.bold))),
                          DataCell(Text(team['nrr'])),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
