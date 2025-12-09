import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:funquiz_apps/models/quiz_item.dart';
import 'package:funquiz_apps/services/quiz_service.dart';
import 'package:funquiz_apps/main.dart'; 

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});
  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final QuizService _quizService = QuizService();
  final GlobalKey<FlipCardState> _cardKey = GlobalKey<FlipCardState>();

  // Future untuk menampung data (state asynchronous)
  late Future<List<QuizItem>> _questionsFuture;
  
  String _categoryName = "Quiz";
  List<QuizItem> _questions = [];
  int _currentIndex = 0;
  bool _isFavorite = false;
  
  // Flag untuk memastikan data hanya diload sekali saat inisialisasi
  bool _isDataLoaded = false;
  bool _isFavoriteStatusChecked = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Memastikan request API hanya dipanggil sekali saat halaman dibuka
    if (!_isDataLoaded) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is String) {
        _categoryName = args;
        _loadQuizData(); // Panggil fungsi fetch data
      }
      _isDataLoaded = true;
    }
  }

  // Fungsi untuk memanggil API (Bisa dipanggil ulang saat Error/Retry)
  void _loadQuizData() {
    setState(() {
      // Mengisi Future dengan request baru
      _questionsFuture = _quizService.getQuestionsForCategory(_categoryName);
    });
  }

  // --- Fungsi Data (Shared Preferences) ---
  void _incrementCardsRevealed() async {
    final prefs = await SharedPreferences.getInstance();
    int currentCount = prefs.getInt('cardsRevealed') ?? 0;
    await prefs.setInt('cardsRevealed', currentCount + 1);
  }

  void _checkFavoriteStatus(String questionText) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favoriteQuestions') ?? [];
    if (mounted) {
      setState(() {
        _isFavorite = favorites.contains(questionText);
      });
    }
  }

  void _toggleFavorite(String questionText) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favoriteQuestions') ?? [];
    
    setState(() {
      if (_isFavorite) {
        favorites.remove(questionText);
        _isFavorite = false;
      } else {
        favorites.add(questionText);
        _isFavorite = true;
      }
    });
    await prefs.setStringList('favoriteQuestions', favorites);
  }

  // --- Fungsi Navigasi Kartu ---
  void _goToNext() {
    if (_currentIndex < _questions.length - 1) {
      if (!_cardKey.currentState!.isFront) {
        _cardKey.currentState!.toggleCard();
      }
      // Delay sedikit agar animasi flip selesai baru ganti soal (opsional)
      setState(() { 
        _currentIndex++; 
        _checkFavoriteStatus(_questions[_currentIndex].question);
      });
    }
  }

  void _goToPrevious() {
    if (_currentIndex > 0) {
      if (!_cardKey.currentState!.isFront) {
        _cardKey.currentState!.toggleCard();
      }
      setState(() { 
        _currentIndex--; 
        _checkFavoriteStatus(_questions[_currentIndex].question);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_categoryName),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: _isFavorite ? Colors.red : kPrimaryColor,
            ),
            onPressed: () {
              if (_questions.isNotEmpty) {
                _toggleFavorite(_questions[_currentIndex].question);
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      // --- PENERAPAN ASYNCHRONOUS UI (Syarat UAS) ---
      body: FutureBuilder<List<QuizItem>>(
        future: _questionsFuture,
        builder: (context, snapshot) {
          
          // 1. STATE LOADING (Sedang mengambil data)
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: kPrimaryColor),
            );
          }

          // 2. STATE ERROR (Gagal koneksi / API Error)
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wifi_off_rounded, size: 80, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      "Gagal memuat data.",
                      style: TextStyle(fontSize: 18, color: Colors.grey[800]),
                    ),
                    Text(
                      "Periksa koneksi internet Anda.",
                      style: TextStyle(color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    // Tombol Retry (Penting untuk UX)
                    ElevatedButton.icon(
                      onPressed: () {
                        // Logic untuk mencoba lagi (refresh future)
                        _loadQuizData();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text("Coba Lagi"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        foregroundColor: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            );
          }

          // 3. STATE SUCCESS (Data berhasil didapat)
          if (snapshot.hasData) {
            _questions = snapshot.data!;
            
            // Handle jika data kosong (Empty State)
            if (_questions.isEmpty) {
              return const Center(child: Text("Tidak ada pertanyaan untuk kategori ini."));
            }

            // Cek status favorit untuk soal pertama (hanya sekali)
            if (!_isFavoriteStatusChecked) {
              _checkFavoriteStatus(_questions[0].question);
              _isFavoriteStatusChecked = true;
            }

            final currentQuestion = _questions[_currentIndex];
            final progress = (_currentIndex + 1) / _questions.length;

            // Render Tampilan Utama Quiz
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // --- Progress Bar ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Question ${_currentIndex + 1}/${_questions.length}',
                        style: TextStyle(color: Colors.grey.shade700, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(kAccentColor),
                    borderRadius: BorderRadius.circular(10),
                    minHeight: 8,
                  ),
                  
                  const SizedBox(height: 24),

                  // --- KARTU FLIP (Inti Quiz) ---
                  Expanded(
                    child: Center(
                      child: FlipCard(
                        key: _cardKey,
                        flipOnTouch: true,
                        direction: FlipDirection.HORIZONTAL,
                        onFlip: () {
                          if (!_cardKey.currentState!.isFront) {
                            _incrementCardsRevealed();
                          }
                        },
                        front: _buildCardContent(
                          text: currentQuestion.question,
                          isQuestion: true,
                          bgColor: Colors.white,
                          textColor: kTextColor,
                        ),
                        back: _buildCardContent(
                          text: currentQuestion.answer,
                          isQuestion: false,
                          bgColor: kPrimaryColor,
                          textColor: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // --- Tombol Navigasi (Prev / Next) ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Tombol Previous
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _currentIndex > 0 ? _goToPrevious : null,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            foregroundColor: kPrimaryColor,
                            side: BorderSide(
                              color: _currentIndex > 0 ? kPrimaryColor : Colors.grey.shade300
                            ),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Previous', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Tombol Next
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _currentIndex < _questions.length - 1 ? _goToNext : null,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: kPrimaryColor,
                            disabledBackgroundColor: Colors.grey.shade300,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Text(
                            'Next', 
                            style: TextStyle(fontSize: 16, color: _currentIndex < _questions.length - 1 ? Colors.white : Colors.grey)
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }

          // Fallback (seharusnya tidak terpanggil)
          return const Center(child: Text("Memulai Quiz..."));
        },
      ),
    );
  }

  // Widget Helper untuk Kartu
  Widget _buildCardContent({
    required String text,
    required bool isQuestion,
    required Color bgColor,
    required Color textColor,
  }) {
    return Container(
      width: double.infinity,
      height: 400, // Sedikit diperbesar agar muat teks panjang
      padding: const EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView( // Agar teks panjang bisa discroll
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        height: 1.3,
                      ),
                ),
              ),
            ),
          ),
          if (isQuestion)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.touch_app, size: 18, color: Colors.grey.shade500),
                  const SizedBox(width: 8),
                  Text(
                    'Tap card to see answer',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}