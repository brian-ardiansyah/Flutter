import 'package:flutter/material.dart';
import 'home_page.dart'; // Pastikan file ini ada dan benar.

class ResultPage extends StatelessWidget {
  final String riskResult;

  const ResultPage({super.key, required this.riskResult});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hasil Prediksi")),
      bottomNavigationBar: _buildBottomNav(1, context),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Text(
            "Hasil Prediksi: $riskResult",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}


// ------------------------------
// Bottom Navigation Builder
// ------------------------------
Widget _buildBottomNav(int currentIndex, BuildContext context) {
  return BottomNavigationBar(
    currentIndex: currentIndex,
    items: const [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      BottomNavigationBarItem(icon: Icon(Icons.search), label: "Prediction"),
      BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: "Account"),
    ],
    onTap: (index) {
      if (index == 0) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
          (_) => false,
        );
      }
    },
  );
}
