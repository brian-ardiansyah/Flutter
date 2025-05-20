import 'package:flutter/material.dart';
import 'prediction_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CekParu'), centerTitle: true),
      bottomNavigationBar: _buildBottomNav(0, context),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const Text(
              "Hi!",
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
                  child: _buildFeatureCard(
                    icon: Icons.analytics,
                    title: "Prediction",
                    onTap: () => Navigator.pushNamed(context, '/prediction'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildFeatureCard(
                    icon: Icons.menu_book,
                    title: "Learn",
                    onTap: () {
                      // TODO: Implement learn feature
                    },
                  ),
                ),
              ],
            ),

            const Spacer(),

            // Tombol Mulai
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/prediction'),
                child: const Text("Mulai Prediksi"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 40),
              const SizedBox(height: 8),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav(int selectedIndex, BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) {
        if (index == 1) {
          Navigator.pushNamed(context, '/prediction');
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics),
          label: "Prediction",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
      ],
    );
  }
}
