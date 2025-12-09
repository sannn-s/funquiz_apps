import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:funquiz_apps/main.dart'; 
import 'package:funquiz_apps/pages/settings_page.dart';
import 'package:funquiz_apps/pages/favorite_page.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _cardsRevealed = 0;
  int _favoritesCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  // Fungsi memuat data profil
  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    final cards = prefs.getInt('cardsRevealed') ?? 0;
    final favList = prefs.getStringList('favoriteQuestions') ?? [];
    
    if (mounted) {
      setState(() {
        _cardsRevealed = cards;
        _favoritesCount = favList.length;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Data Dummy User
    const String userName = 'Ahsan Azhari';
    const String userEmail = 'aanahsan46@gmail.com';

    return Scaffold(
      backgroundColor: kBackgroundColor, // Warna background abu muda
      appBar: AppBar(
        title: const Text(
          'My Profile', 
          style: TextStyle(fontWeight: FontWeight.bold, color: kTextColor)
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          color: kPrimaryColor, 
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: kPrimaryColor))
        : SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Column(
              children: [
                const SizedBox(height: 10),
                
                // --- 1. AVATAR DENGAN GRADIENT BORDER ---
                Container(
                  padding: const EdgeInsets.all(4), 
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    // Efek lingakaran pelangi/gradient (Ungu ke Teal)
                    gradient: LinearGradient(
                      colors: [kPrimaryColor, kAccentColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white, // Border putih pemisah
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: kBackgroundColor,
                      child: const Icon(Icons.person, size: 60, color: kPrimaryColor),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // --- 2. TEXT INFO USER ---
                const Text(
                  userName,
                  style: TextStyle(
                    fontSize: 24, 
                    fontWeight: FontWeight.bold, 
                    color: kTextColor
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  userEmail,
                  style: TextStyle(
                    fontSize: 14, 
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 30),

                // --- 3. KARTU STATISTIK (MODERN) ---
                Row(
                  children: [
                    Expanded(
                      child: _buildModernStatCard(
                        title: "Revealed",
                        value: _cardsRevealed.toString(),
                        icon: Icons.style,
                        color: kAccentColor, // Teal
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildModernStatCard(
                        title: "Favorites",
                        value: _favoritesCount.toString(),
                        icon: Icons.favorite,
                        color: Colors.pinkAccent, // Pink
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // --- 4. MENU OPSI ---
                // Menu Favorit
                _buildMenuTile(
                  title: "Favorite Cards",
                  icon: Icons.favorite_border_rounded,
                  accentColor: Colors.pink,
                  onTap: () async {
                    // Navigasi ke halaman favorit
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FavoritePage()),
                    );
                    // Refresh data saat kembali
                    _loadProfileData();
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Menu Settings
                _buildMenuTile(
                  title: "Settings",
                  icon: Icons.settings_outlined,
                  accentColor: kPrimaryColor,
                  onTap: () async {
                    // Navigasi ke halaman settings
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SettingsPage()),
                    );
                    // Refresh data saat kembali
                    _loadProfileData();
                  },
                ),

                const SizedBox(height: 40),

                // --- 5. TOMBOL LOGOUT ---
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Logout dan hapus semua riwayat navigasi
                      Navigator.pushNamedAndRemoveUntil(
                        context, 
                        '/login', 
                        (route) => false 
                      );
                    },
                    icon: const Icon(Icons.logout_rounded),
                    label: const Text("Log Out"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red.shade400,
                      side: BorderSide(color: Colors.red.shade100, width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)
                      ),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
    );
  }

  // --- WIDGET HELPER 1: Kartu Statistik ---
  Widget _buildModernStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 26, 
              fontWeight: FontWeight.bold, 
              color: kTextColor
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12, 
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET HELPER 2: Menu Item ---
  Widget _buildMenuTile({
    required String title,
    required IconData icon,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: accentColor, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: kTextColor,
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey.shade300),
              ],
            ),
          ),
        ),
      ),
    );
  }
}