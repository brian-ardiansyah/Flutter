import 'package:flutter/material.dart';
import 'home_page.dart'; // Pastikan file ini ada

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildBottomNav(0, context),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const Text(
              "Hi Rawls!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text("May you always be in a good condition"),
            const SizedBox(height: 20),

            // Banner Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal[50],
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Deteksi Risiko Kanker Paru-Paru Lebih Awal",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text("Ketahui kondisi kanker saat ini. Cari tahu sekarang!"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Fitur: Prediction & Learn
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: const [
                      Icon(Icons.analytics, size: 40),
                      SizedBox(height: 8),
                      Text("Prediction"),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: const [
                      Icon(Icons.menu_book, size: 40),
                      SizedBox(height: 8),
                      Text("Learn"),
                    ],
                  ),
                ),
              ],
            ),

            const Spacer(),

            // Tombol Mulai
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HomePage()),
                  );
                },
                child: const Text("Mulai Prediksi"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(int selectedIndex, BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) {
        // Tambahkan navigasi antar halaman jika perlu
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.analytics), label: "Prediction"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
      ],
    );
  }
}
