import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  // Ensure Flutter engine is initialized before starting Supabase
  WidgetsFlutterBinding.ensureInitialized();
  
  // We will replace these with your actual Supabase keys in Phase 2
  await Supabase.initialize(
    url: 'https://your-project-url.supabase.co',
    anonKey: 'your-anon-key',
  );

  // ProviderScope allows Riverpod to manage our rapid ball-by-ball state
  runApp(const ProviderScope(child: LiveScoreApp()));
}

class LiveScoreApp extends StatelessWidget {
  const LiveScoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LiveScore',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B132B), // Dark Navy Background
        primaryColor: const Color(0xFF2ECC71), // Cricket Green
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1C2541), // Royal Blue Surface
          elevation: 0,
        ),
      ),
      home: const InitialScreen(),
    );
  }
}

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LiveScore', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.sports_cricket, size: 80, color: Color(0xFF2ECC71)),
            const SizedBox(height: 20),
            const Text(
              'Local Match Engine Ready',
              style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Text(
              'Connected to Supabase Backend',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
