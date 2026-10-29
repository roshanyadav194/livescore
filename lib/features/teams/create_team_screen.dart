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
    if (_nameController.text.isEmpty || _cityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields'), backgroundColor: Colors.redAccent),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // THIS IS THE MAGIC! It securely sends your team data straight to Supabase
      await Supabase.instance.client.from('teams').insert({
        'name': _nameController.text.trim(),
        'city': _cityController.text.trim(),
        'created_by': Supabase.instance.client.auth.currentUser?.id,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Team Saved to Cloud Successfully!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            backgroundColor: Color(0xFF2ECC71),
          ),
        );
        Navigator.pop(context); // Go back to Dashboard
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
                fillColor: const Color(0xFF1C2541),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16),
            
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
            
            ElevatedButton(
              onPressed: _isLoading ? null : _saveTeam,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2ECC71),
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
