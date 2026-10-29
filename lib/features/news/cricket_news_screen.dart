import 'package:flutter/material.dart';
import 'dart:convert';
// import 'package:http/http.dart' as http; // Uncomment when adding your real API key!

class CricketNewsScreen extends StatefulWidget {
  const CricketNewsScreen({super.key});

  @override
  State<CricketNewsScreen> createState() => _CricketNewsScreenState();
}

class _CricketNewsScreenState extends State<CricketNewsScreen> {
  List<dynamic> _newsArticles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLiveNews();
  }

  Future<void> _fetchLiveNews() async {
    // In a production app, you would execute a real HTTP GET request here:
    // final response = await http.get(Uri.parse('https://newsapi.org/v2/top-headlines?category=sports&q=cricket&apiKey=YOUR_API_KEY'));
    
    // For now, we simulate network latency and an API response so you can test the UI instantly!
    await Future.delayed(const Duration(seconds: 2)); 
    
    final mockApiResponse = '''
    {
      "articles": [
        {
          "title": "Virat Kohli hits stunning century in thrilling run chase for Bengaluru",
          "source": "ProCricket API",
          "time": "2 hours ago"
        },
        {
          "title": "World Cup Qualifiers: Upsets and drama on Day 4",
          "source": "Global Sports",
          "time": "4 hours ago"
        },
        {
          "title": "New T20 league announces player draft dates",
          "source": "Cricket Daily",
          "time": "6 hours ago"
        }
      ]
    }
    ''';

    if (mounted) {
      setState(() {
        _newsArticles = json.decode(mockApiResponse)['articles'];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pro Cricket News', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1C2541),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF2ECC71)))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _newsArticles.length,
              itemBuilder: (context, index) {
                final article = _newsArticles[index];
                return Card(
                  color: const Color(0xFF1C2541),
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: const Icon(Icons.article, color: Color(0xFF2ECC71), size: 40),
                    title: Text(article['title'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text('${article['source']} • ${article['time']}', style: const TextStyle(color: Colors.white54, fontSize: 12)),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 16),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Opening external article...'), backgroundColor: Color(0xFF3A506B)),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
