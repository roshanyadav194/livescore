import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TournamentHubScreen extends StatefulWidget {
  const TournamentHubScreen({super.key});

  @override
  State<TournamentHubScreen> createState() => _TournamentHubScreenState();
}

class _TournamentHubScreenState extends State<TournamentHubScreen> {
  List> _standings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStandings();
  }

  Future<void> _fetchStandings() async {
    try {
      final data = await Supabase.instance.client
          .from('league_standings')
          .select();
      
      if (mounted) {
        setState(() {
          _standings = List>.from(data);
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching standings: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

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
              'Live League Standings',
              style: TextStyle(color: Color(0xFF2ECC71), fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            
            Expanded(
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF2ECC71)))
                : Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C2541),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(
                          child: DataTable(
                            columnSpacing: 28,
                            // THE FIX IS APPLIED HERE:
                            headingRowColor: WidgetStateProperty.all(const Color(0xFF0B132B)), 
                            headingTextStyle: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
                            dataTextStyle: const TextStyle(color: Colors.white, fontSize: 16),
                            columns: const [
                              DataColumn(label: Text('#')),
                              DataColumn(label: Text('Team')),
                              DataColumn(label: Text('P')),
                              DataColumn(label: Text('W')),
                              DataColumn(label: Text('L')),
                              DataColumn(label: Text('Pts')),
                            ],
                            rows: _standings.asMap().entries.map((entry) {
                              int index = entry.key; 
                              var team = entry.value;
                              return DataRow(
                                cells: [
                                  DataCell(Text('${index + 1}', style: const TextStyle(color: Colors.white54))),
                                  DataCell(Text(team['team'] ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.bold))),
                                  DataCell(Text(team['p'].toString())),
                                  DataCell(Text(team['w'].toString())),
                                  DataCell(Text(team['l'].toString())),
                                  DataCell(Text(team['pts'].toString(), style: const TextStyle(color: Color(0xFF2ECC71), fontWeight: FontWeight.bold))),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
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
