import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:funquiz_apps/main.dart'; // Import warna tema

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<String> _favorites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  // Memuat data dari Shared Preferences
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _favorites = prefs.getStringList('favoriteQuestions') ?? [];
      _isLoading = false;
    });
  }

  // Menghapus item dari favorit
  Future<void> _removeFavorite(String question) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _favorites.remove(question);
    });
    await prefs.setStringList('favoriteQuestions', _favorites);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: const Text(
          "My Favorites",
          style: TextStyle(color: kTextColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          color: kTextColor,
          onPressed: () => Navigator.pop(context, true), // Kembali & Refresh profile
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: kPrimaryColor))
          : _favorites.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  physics: const BouncingScrollPhysics(),
                  itemCount: _favorites.length,
                  itemBuilder: (context, index) {
                    final question = _favorites[index];
                    return _buildFavoriteCard(question, index);
                  },
                ),
    );
  }

  // Widget Tampilan Kosong (Empty State)
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: kPrimaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.favorite_border_rounded, size: 60, color: kPrimaryColor),
          ),
          const SizedBox(height: 20),
          const Text(
            "No Favorites Yet",
            style: TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.bold, 
              color: kTextColor
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Mark questions with ❤️ to see them here.",
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  // Widget Kartu Favorit Modern
  Widget _buildFavoriteCard(String question, int index) {
    return Dismissible(
      key: Key(question),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 30),
      ),
      onDismissed: (direction) {
        _removeFavorite(question);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Removed from favorites"),
            backgroundColor: kPrimaryColor,
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: kAccentColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              "${index + 1}",
              style: const TextStyle(
                color: kAccentColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          title: Text(
            question,
            style: const TextStyle(
              fontWeight: FontWeight.w600, 
              color: kTextColor,
              height: 1.4,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            color: Colors.grey.shade400,
            onPressed: () {
              // Menghapus dengan dialog konfirmasi opsional atau langsung
              _removeFavorite(question);
            },
          ),
        ),
      ),
    );
  }
}