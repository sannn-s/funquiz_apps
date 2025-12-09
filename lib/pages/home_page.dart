import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:funquiz_apps/main.dart'; // Import warna dari main.dart


// --- Model Category ---
class Category {
  final String name;
  final IconData icon;
  Category({required this.name, required this.icon});
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'],
      icon: _getIconData(json['icon']),
    );
  }
  static IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'history': return Icons.history_edu;
      case 'brightness_2_outlined': return Icons.nights_stay_rounded;
      case 'public': return Icons.public;
      case 'movie_outlined': return Icons.movie_filter_rounded;
      case 'music_note_outlined': return Icons.music_note_rounded;
      case 'sports_soccer_outlined': return Icons.sports_soccer_rounded;
      case 'science_outlined': return Icons.science_rounded;
      case 'computer': return Icons.computer_rounded;
      default: return Icons.category_rounded;
    }
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Category> _allCategories = [];
  List<Category> _filteredCategories = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/categories.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      final List<Category> loadedData = jsonList.map((jsonItem) => Category.fromJson(jsonItem)).toList();
      setState(() {
        _allCategories = loadedData;
        _filteredCategories = loadedData;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  void _runFilter(String enteredKeyword) {
    List<Category> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allCategories;
    } else {
      results = _allCategories
          .where((item) => item.name.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _filteredCategories = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      // Kita gunakan Body custom tanpa AppBar bawaan agar desain lebih fleksibel
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: kPrimaryColor))
        : SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header Modern
                _buildModernHeader(), 
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 2. Search Bar (Floating Effect)
                      // Geser ke atas sedikit (-25) agar menumpuk di atas header
                      Transform.translate(
                        offset: const Offset(0, -25),
                        child: _buildSearchBar(),
                      ),
                      
                      const SizedBox(height: 10),
                      
                      // 3. Tombol Random Quiz (Gradient)
                      Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [kAccentColor, Color(0xFF26C6DA)], // Teal Gradient
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: kAccentColor.withOpacity(0.4), 
                              blurRadius: 12, 
                              offset: const Offset(0, 6)
                            )
                          ]
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              Navigator.pushNamed(context, '/quiz', arguments: "Random");
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.shuffle_rounded, color: Colors.white, size: 28),
                                SizedBox(width: 10),
                                Text(
                                  'Start Random Quiz', 
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold, 
                                    color: Colors.white,
                                    fontSize: 18
                                  )
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Judul Bagian Kategori
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Categories",
                            style: TextStyle(
                              fontSize: 20, 
                              fontWeight: FontWeight.bold, 
                              color: kTextColor // Sesuai main.dart
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: kPrimaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: Text(
                              "${_filteredCategories.length} Items",
                              style: const TextStyle(
                                color: kPrimaryColor, 
                                fontWeight: FontWeight.bold,
                                fontSize: 12
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // 4. Grid Kategori
                      _buildCategoryGrid(),
                      
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }

  // WIDGET HELPER: Header
  Widget _buildModernHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 60, left: 24, right: 24, bottom: 50),
      decoration: const BoxDecoration(
        // Gradient Header: Ungu Tua ke Agak Terang
        gradient: LinearGradient(
          colors: [kPrimaryColor, Color(0xFF7E57C2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello, Learner! 👋",
                style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                "Let's Play Quiz",
                style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          // Tombol Profil Kecil di Header
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/profile'),
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const CircleAvatar(
                radius: 26,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: kPrimaryColor, size: 30),
              ),
            ),
          )
        ],
      ),
    );
  }

  // WIDGET HELPER: Search Bar
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _runFilter,
        style: const TextStyle(color: kTextColor),
        decoration: InputDecoration(
          hintText: "Search topic...",
          hintStyle: TextStyle(color: Colors.grey.shade400),
          prefixIcon: const Icon(Icons.search_rounded, color: kPrimaryColor),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  // WIDGET HELPER: Grid Builder
  Widget _buildCategoryGrid() {
    if (_filteredCategories.isEmpty) {
      return Center(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Icon(Icons.search_off_rounded, size: 70, color: Colors.grey.shade300),
            const SizedBox(height: 10),
            Text("No category found", style: TextStyle(color: Colors.grey.shade400)),
          ],
        ),
      );
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.95, // Sedikit lebih tinggi agar teks muat
      ),
      itemCount: _filteredCategories.length,
      itemBuilder: (context, index) {
        final category = _filteredCategories[index];
        return _buildModernCategoryCard(category);
      },
    );
  }

  // WIDGET HELPER: Kartu Kategori Modern
  // Kita buat di sini agar desainnya spesifik untuk halaman ini tanpa edit file lain
  Widget _buildModernCategoryCard(Category category) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/quiz', arguments: category.name);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100,
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon dengan background lingkaran halus
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(category.icon, size: 36, color: kPrimaryColor),
            ),
            const SizedBox(height: 16),
            Text(
              category.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 16, 
                color: kTextColor
              ),
            ),
          ],
        ),
      ),
    );
  }
}