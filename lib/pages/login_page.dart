import 'package:flutter/material.dart';
import 'package:funquiz_apps/main.dart'; // Import warna tema

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controller untuk membaca input pengguna
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // --- LOGIKA VALIDASI LOGIN ---
  void _handleLogin() {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // 1. Cek apakah kosong
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Email dan Password tidak boleh kosong!"),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    // 2. Cek panjang password (Simulasi keamanan)
    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Password minimal 6 karakter!"),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: kPrimaryColor)),
    );

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        Navigator.pop(context); // Tutup loading
        Navigator.pushReplacementNamed(context, '/home'); // Masuk aplikasi
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- BAGIAN 1: HEADER GRADIENT MELENGKUNG ---
            Stack(
              children: [
                // Background Gradient
                Container(
                  height: size.height * 0.35,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [kPrimaryColor, kAccentColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(60),
                      bottomRight: Radius.circular(60),
                    ),
                  ),
                ),
                // Konten Header
                Positioned(
                  top: 60, left: 0, right: 0,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 20, offset: const Offset(0, 10))
                          ],
                        ),
                        child: const Icon(Icons.quiz_rounded, size: 50, color: kPrimaryColor),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Fun Quiz",
                        style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Learn. Play. Repeat.",
                        style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // --- BAGIAN 2: FORM INPUT ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Login to your account",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kTextColor),
                  ),
                  const SizedBox(height: 30),

                  // Input Email (Sekarang pakai Controller)
                  _buildModernTextField(
                    controller: _emailController,
                    hint: "Email Address",
                    icon: Icons.email_outlined,
                    inputType: TextInputType.emailAddress,
                  ),
                  
                  const SizedBox(height: 20),

                  // Input Password (Sekarang pakai Controller)
                  _buildModernTextField(
                    controller: _passwordController,
                    hint: "Password",
                    icon: Icons.lock_outline,
                    isPassword: true,
                  ),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text("Forgot Password?", style: TextStyle(color: kAccentColor, fontWeight: FontWeight.w600)),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Tombol Login (Panggil fungsi _handleLogin)
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(color: kPrimaryColor.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8)),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _handleLogin, // AKSI KLIK TOMBOL
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 0,
                      ),
                      child: const Text(
                        "LOG IN",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // --- BAGIAN 3: SOCIAL LOGIN ---
                  Center(child: Text("- Or sign in with -", style: TextStyle(color: Colors.grey.shade500))),
                  const SizedBox(height: 20),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialButton(Icons.g_mobiledata),
                      const SizedBox(width: 20),
                      _buildSocialButton(Icons.facebook),
                      const SizedBox(width: 20),
                      _buildSocialButton(Icons.apple),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? ", style: TextStyle(color: Colors.grey.shade600)),
                      GestureDetector(
                        onTap: () {},
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // WIDGET HELPER: Input Field Modern
  // Ditambahkan parameter 'controller'
  Widget _buildModernTextField({
    required TextEditingController controller, // Wajib diisi controller
    required String hint,
    required IconData icon,
    bool isPassword = false,
    TextInputType inputType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller, // Pasang controller di sini
        obscureText: isPassword,
        keyboardType: inputType,
        style: const TextStyle(color: kTextColor),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          prefixIcon: Icon(icon, color: kPrimaryColor.withOpacity(0.6)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: kPrimaryColor, width: 1.5)
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: Icon(icon, size: 32, color: kTextColor),
    );
  }
}