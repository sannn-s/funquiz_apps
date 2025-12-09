import 'dart:convert';
import 'package:http/http.dart' as http; // Import package http
import 'package:funquiz_apps/models/quiz_item.dart';

class QuizService {
  // URL Database Firebase Anda (dengan akhiran .json)
  static const String baseUrl = 'https://funquiz-123-default-rtdb.firebaseio.com/.json';

  // Fungsi privat untuk mengambil data dari Internet (HTTP Request)
  Future<Map<String, dynamic>> _fetchQuizDataFromApi() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        // Jika server mengembalikan respons OK (200), parse JSON-nya
        // Pastikan body tidak null atau kosong
        if (response.body.isEmpty || response.body == 'null') {
           return {};
        }
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        // Jika server error (bukan 200)
        throw Exception('Failed to load quiz data. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      // Tangkap error koneksi (misal tidak ada internet)
      throw Exception('Error connecting to database: $e');
    }
  }

  // Fungsi publik untuk mendapatkan pertanyaan (Logika tetap sama, sumber data berubah)
  Future<List<QuizItem>> getQuestionsForCategory(String categoryName) async {
    // Panggil fungsi fetch data dari API
    final allData = await _fetchQuizDataFromApi();

    if (allData.isEmpty) {
       throw Exception("Database is empty or failed to load");
    }

    if (categoryName == "Random") {
      // --- Logika untuk Kuis Random ---
      List<QuizItem> allQuestions = [];
      
      // Kumpulkan semua pertanyaan dari semua kategori di database
      allData.forEach((key, value) {
        // Cek jika value adalah List (karena struktur JSON di Firebase harus valid)
        if (value is List) {
           final List<dynamic> questionsList = value;
           allQuestions.addAll(questionsList.map((q) => QuizItem.fromJson(q)));
        }
      });
      
      // Acak daftarnya
      allQuestions.shuffle();
      
      // Ambil 10 pertanyaan pertama (atau kurang jika total soal < 10)
      return allQuestions.take(10).toList();

    } else {
      // --- Logika untuk Kategori Spesifik ---
      if (allData.containsKey(categoryName)) {
        final List<dynamic> questionsList = allData[categoryName];
        // Ubah list of maps menjadi list of QuizItem
        return questionsList.map((q) => QuizItem.fromJson(q)).toList();
      } else {
        // Jika kategori tidak ditemukan di Database
        throw Exception("Category '$categoryName' not found in database");
      }
    }
  }
}