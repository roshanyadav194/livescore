import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddPlayerScreen extends StatefulWidget {
  const AddPlayerScreen({super.key});

  @override
  State<AddPlayerScreen> createState() => _AddPlayerScreenState();
}

class _AddPlayerScreenState extends State<AddPlayerScreen> {
  final TextEditingController _nameController = TextEditingController();
  String _selectedRole = 'All-Rounder';
  bool _isLoading = false;

  Future<void> _savePlayer() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a player name'), backgroundColor: Colors.redAccent),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Saves the player's name and role to the cloud
      await Supabase.instance.client.from('players').insert({
        'name': _nameController.text.trim(),
        'role': _selectedRole,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Player added successfully!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            backgroundColor: Color(0xFF2ECC71),
          ),
        );
        _nameController.clear(); // Clears the box so you can quickly add another player
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
        title: const Text('Add Player', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1C2541),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.person_add, size: 80, color: Color(0xFF2ECC71)),
            const SizedBox(height: 24),
            
            // PLAYER NAME INPUT
            TextField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Player Name',
                labelStyle: const TextStyle(color: Colors.white70),
                hintText: 'e.g. Virat Kohli',
                hintStyle: const TextStyle(color: Colors.white38),
                prefixIcon: const Icon(Icons.person, color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF1C2541), // Royal Blue
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16),
            
            // PLAYER ROLE DROPDOWN
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF1C2541),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedRole,
                  dropdownColor: const Color(0xFF1C2541),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white54),
                  isExpanded: true,
                  items: ['Batter', 'Bowler', 'All-Rounder', 'Wicket-Keeper'].map((String role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedRole = newValue;
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            // SAVE BUTTON
            ElevatedButton(
              onPressed: _isLoading ? null : _savePlayer,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2ECC71),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _isLoading 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Color(0xFF0B132B), strokeWidth: 2))
                  : const Text('Save Player', style: TextStyle(color: Color(0xFF0B132B), fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
