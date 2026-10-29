import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateTeamScreen extends StatefulWidget {
  const CreateTeamScreen({super.key});

  @override
  State<CreateTeamScreen> createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends State<CreateTeamScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  bool _isLoading = false;

  Future<void> _saveTeam() async {
    // 1. Check if the user filled out both boxes
    if (_nameController.text.isEmpty || _cityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields'), backgroundColor: Colors.redAccent),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 2. This is where it will securely save to your Supabase Database
      /*
      await Supabase.instance.client.from('teams').insert({
        'name': _nameController.text.trim(),
        'city': _cityController.text.trim(),
        'created_by': Supabase.instance.client.auth.currentUser?.id,
      });
      */
      
      // Simulating a quick network save for now
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Team Created Successfully!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            backgroundColor: Color(0xFF2ECC71),
          ),
        );
        // Go back to the previous screen after saving
        Navigator.pop(context);
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error'), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Team', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.shield_outlined, size: 80, color: Color(0xFF2ECC71)),
            const SizedBox(height: 24),
            
            // TEAM NAME INPUT
            TextField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Team Name',
                labelStyle: const TextStyle(color: Colors.white70),
                hintText: 'e.g. Royal Challengers',
                hintStyle: const TextStyle(color: Colors.white38),
                prefixIcon: const Icon(Icons.sports_cricket, color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF1C2541), // Royal Blue
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16),
            
            // CITY/LOCATION INPUT
            TextField(
              controller: _cityController,
              textCapitalization: TextCapitalization.words,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'City / Location',
                labelStyle: const TextStyle(color: Colors.white70),
                hintText: 'e.g. Prayagraj',
                hintStyle: const TextStyle(color: Colors.white38),
                prefixIcon: const Icon(Icons.location_city, color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF1C2541),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 32),
            
            // SAVE BUTTON
            ElevatedButton(
              onPressed: _isLoading ? null : _saveTeam,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2ECC71), // Cricket Green
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _isLoading 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Color(0xFF0B132B), strokeWidth: 2))
                  : const Text('Save Team', style: TextStyle(color: Color(0xFF0B132B), fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
