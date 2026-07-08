import 'package:flutter/material.dart';
import '../core/globals.dart';
import 'main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoginMahasiswa = true;
  final userCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final kodeCtrl = TextEditingController();

  void login() {
    bool success = false;

    if (isLoginMahasiswa) {
      if (kodeCtrl.text.trim().isNotEmpty) success = true;
    } else {
      if (userCtrl.text.trim() == "dosen" && passCtrl.text == "admin123") {
        success = true;
      }
    }

    if (success) {
      // Hilangkan keyboard sebelum pindah halaman
      FocusScope.of(context).unfocus();
      isMahasiswaRole = isLoginMahasiswa;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 10),
              Expanded(child: Text('Login Gagal! Cek kembali data Anda.')),
            ],
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF5F7FA,
      ), // Background abu-abu sangat muda ala web modern
      body: SafeArea(
        child: Column(
          children: [
            // HEADER LENTERA UINAM PRO
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1B5E20), Color(0xFF4CAF50)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/logo_uinam.png',
                    height: 50,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.school, size: 50, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    "LabClass",
                    style: TextStyle(
                      fontSize: 28,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(
                      maxWidth: 400,
                    ), // Max lebar dibatasi agar tidak melar di tablet
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        16,
                      ), // Ujung melengkung mulus
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // JUDUL FORM
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            border: Border(
                              bottom: BorderSide(color: Colors.grey.shade200),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            "Login Portal",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1B5E20),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // TOGGLE ROLE PRO
                              Row(
                                children: [
                                  Expanded(
                                    child: ChoiceChip(
                                      label: const Center(
                                        child: Text("Mahasiswa"),
                                      ),
                                      selected: isLoginMahasiswa,
                                      showCheckmark: false,
                                      labelStyle: TextStyle(
                                        // Teks Putih jika dipilih, Teks Hijau Tua jika tidak dipilih
                                        color: isLoginMahasiswa
                                            ? Colors.white
                                            : const Color(0xFF1B5E20),
                                        fontWeight: FontWeight.bold,
                                      ),
                                      selectedColor: const Color(0xFF1B5E20),
                                      // Tambahkan ini agar warna chip saat tidak dipilih lebih terang
                                      backgroundColor: const Color(0xFFE8F5E9),
                                      onSelected: (val) => setState(
                                        () => isLoginMahasiswa = true,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ChoiceChip(
                                      label: const Center(child: Text("Dosen")),
                                      selected: !isLoginMahasiswa,
                                      showCheckmark: false,
                                      labelStyle: TextStyle(
                                        color: !isLoginMahasiswa
                                            ? Colors.white
                                            : const Color(0xFF1B5E20),
                                        fontWeight: FontWeight.bold,
                                      ),
                                      selectedColor: const Color(0xFF1B5E20),
                                      // Tambahkan ini agar warna chip saat tidak dipilih lebih terang
                                      backgroundColor: const Color(0xFFE8F5E9),
                                      onSelected: (val) => setState(
                                        () => isLoginMahasiswa = false,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // FORM INPUT PRO
                              if (isLoginMahasiswa) ...[
                                TextField(
                                  controller: kodeCtrl,
                                  style: const TextStyle(color: Colors.black),
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  onSubmitted: (_) => login(),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors
                                        .white, // KUNCI BACKGROUND KOLOM KE PUTIH
                                    prefixIcon: const Icon(
                                      Icons.badge,
                                      color: Color(0xFF1B5E20),
                                    ),
                                    labelText: "NIM Mahasiswa",
                                    hintText: "Contoh: 60200123002",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF1B5E20),
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ] else ...[
                                TextField(
                                  controller: userCtrl,
                                  style: const TextStyle(color: Colors.black),
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors
                                        .white, // KUNCI BACKGROUND KOLOM KE PUTIH
                                    prefixIcon: const Icon(
                                      Icons.person,
                                      color: Color(0xFF1B5E20),
                                    ),
                                    labelText: "Username",
                                    hintText: "Gunakan: dosen",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF1B5E20),
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                  controller: passCtrl,
                                  obscureText: true,
                                  style: const TextStyle(color: Colors.black),
                                  textInputAction: TextInputAction.done,
                                  onSubmitted: (_) => login(),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors
                                        .white, // KUNCI BACKGROUND KOLOM KE PUTIH
                                    hintStyle: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.lock,
                                      color: Color(0xFF1B5E20),
                                    ),
                                    labelText: "Password",
                                    hintText: "Gunakan: admin123",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF1B5E20),
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              const SizedBox(height: 32),

                              // TOMBOL LOGIN PRO
                              SizedBox(
                                height:
                                    50, // Tombol lebih tebal agar enak ditekan di layar sentuh
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1B5E20),
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: login,
                                  child: const Text(
                                    "MASUK",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
