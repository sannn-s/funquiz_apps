import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:funquiz_apps/main.dart'; // Import warna tema

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // Fungsi Reset Data
  Future<void> _resetData(BuildContext context, String key, String message) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message, style: const TextStyle(color: Colors.white)),
          backgroundColor: kAccentColor, // Menggunakan Teal
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  // Dialog Konfirmasi Modern
  void _showConfirmationDialog(BuildContext context, String title, String content, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          title, 
          style: const TextStyle(color: kTextColor, fontWeight: FontWeight.bold)
        ),
        content: Text(
          content, 
          style: TextStyle(color: Colors.grey.shade600)
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text("Cancel", style: TextStyle(color: Colors.grey.shade400)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("Yes, Clear", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(color: kTextColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          color: kTextColor,
          onPressed: () => Navigator.pop(context, true), // Return true to refresh
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("General"),
            const SizedBox(height: 10),
            
            // --- KARTU SETTING 1 ---
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.grey.shade100, blurRadius: 10, offset: const Offset(0, 5)),
                ],
              ),
              child: Column(
                children: [
                  _buildSettingTile(
                    context,
                    icon: Icons.refresh_rounded,
                    iconColor: Colors.blueAccent,
                    title: "Reset Progress",
                    subtitle: "Set 'Cards Revealed' to 0",
                    onTap: () {
                      _showConfirmationDialog(
                        context, 
                        "Reset Progress?", 
                        "Are you sure you want to reset your learning progress? This cannot be undone.",
                        () => _resetData(context, 'cardsRevealed', "Progress has been reset!")
                      );
                    },
                  ),
                  Divider(height: 1, color: Colors.grey.shade100),
                  _buildSettingTile(
                    context,
                    icon: Icons.delete_outline_rounded,
                    iconColor: Colors.redAccent,
                    title: "Clear Favorites",
                    subtitle: "Remove all bookmarked questions",
                    onTap: () {
                      _showConfirmationDialog(
                        context, 
                        "Clear Favorites?", 
                        "Are you sure you want to delete all your favorite cards?",
                        () => _resetData(context, 'favoriteQuestions', "Favorites cleared!")
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
            _buildSectionTitle("App Info"),
            const SizedBox(height: 10),

            // --- KARTU SETTING 2 ---
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.grey.shade100, blurRadius: 10, offset: const Offset(0, 5)),
                ],
              ),
              child: Column(
                children: [
                  _buildSettingTile(
                    context,
                    icon: Icons.info_outline_rounded,
                    iconColor: Colors.purpleAccent,
                    title: "Version",
                    subtitle: "1.0.0 (UAS Edition)",
                    onTap: () {}, // No action
                  ),
                  Divider(height: 1, color: Colors.grey.shade100),
                  _buildSettingTile(
                    context,
                    icon: Icons.code_rounded,
                    iconColor: kAccentColor,
                    title: "Developer",
                    subtitle: "Ahsan Azhari",
                    onTap: () {}, // No action
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            Center(
              child: Text(
                "Fun Quiz App 2025",
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.grey.shade500,
          fontWeight: FontWeight.bold,
          fontSize: 13,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingTile(BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor, size: 24),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, color: kTextColor, fontSize: 16),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
      ),
      trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey.shade300),
    );
  }
}