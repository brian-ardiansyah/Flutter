import 'package:flutter/material.dart';
// import '../services/api_service.dart';
import 'result_page.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  String? gender;
  final TextEditingController ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Deteksi Risiko Kanker")),
      bottomNavigationBar: buildBottomNav(1, context),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Kamu bisa mengetahui seberapa besar risiko terkena penyakit kanker saat ini.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: const Text("Laki-Laki"),
                  selected: gender == "Laki-Laki",
                  onSelected: (_) => setState(() => gender = "Laki-Laki"),
                ),
                const SizedBox(width: 10),
                ChoiceChip(
                  label: const Text("Perempuan"),
                  selected: gender == "Perempuan",
                  onSelected: (_) => setState(() => gender = "Perempuan"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Berapa Usia Kamu",
                suffixText: "Thn",
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (gender != null && ageController.text.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => QuestionPage(
                          gender: gender!,
                          age: int.tryParse(ageController.text) ?? 0,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Lengkapi data terlebih dahulu!")),
                    );
                  }
                },
                child: const Text("Lanjutkan"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuestionPage extends StatefulWidget {
  final String gender;
  final int age;

  const QuestionPage({super.key, required this.gender, required this.age});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  bool? passiveSmoker;
  bool? anxiety;
  bool? chronic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Deteksi Risiko Kanker")),
      bottomNavigationBar: buildBottomNav(1, context),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Lanjutkan Pengisian", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            buildQuestion("Apakah Anda seorang perokok pasif?", (val) {
              setState(() => passiveSmoker = val);
            }),
            buildQuestion("Apakah Anda sering mengalami kecemasan?", (val) {
              setState(() => anxiety = val);
            }),
            buildQuestion("Apakah Anda memiliki penyakit kronis?", (val) {
              setState(() => chronic = val);
            }),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: cekHasil,
                child: const Text("Cek Hasil"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildQuestion(String text, Function(bool) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => onChanged(true),
                child: const Text("Iya"),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton(
                onPressed: () => onChanged(false),
                child: const Text("Tidak"),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  void cekHasil() async {
    if (passiveSmoker == null || anxiety == null || chronic == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Jawaban harus lengkap!")),
      );
      return;
    }

    final data = {
      "GENDER": widget.gender == "Laki-Laki" ? 1 : 0,
      "AGE": widget.age,
      "SMOKING": passiveSmoker! ? 1 : 0,
      "ANXIETY": anxiety! ? 1 : 0,
      "CHRONIC DISEASE": chronic! ? 1 : 0,
    };

    try {
      final hasil = await ApiService.predictRisk(data);
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResultPage(riskResult: hasil),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memproses data: $e")),
      );
    }
  }
}

// Fungsi bottom navigation
Widget buildBottomNav(int selectedIndex, BuildContext context) {
  return BottomNavigationBar(
    currentIndex: selectedIndex,
    onTap: (index) {
      // navigasi jika diperlukan
    },
    items: const [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      BottomNavigationBarItem(icon: Icon(Icons.analytics), label: "Prediction"),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
    ],
  );
}
