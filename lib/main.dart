import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/match_setup/match_setup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://your-project-url.supabase.co',
    anonKey: 'your-anon-key',
  );

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
        scaffoldBackgroundColor: const Color(0xFF0B132B), // Dark Navy
        primaryColor: const Color(0xFF2ECC71), // Cricket Green
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1C2541), // Royal Blue
          elevation: 0,
        ),
      ),
      home: const MatchSetupScreen(), // This is the magic line that connects your new screen!
    );
  }
}
