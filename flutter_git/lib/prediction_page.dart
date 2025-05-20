import 'package:flutter/material.dart';
import 'services/api_service.dart';
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
      body: SingleChildScrollView(
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
                border: OutlineInputBorder(),
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
                        builder:
                            (_) => QuestionPage(
                              gender: gender!,
                              age: int.tryParse(ageController.text) ?? 0,
                            ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Lengkapi data terlebih dahulu!"),
                      ),
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
  bool? yellowFingers;
  bool? anxiety;
  bool? peerPressure;
  bool? chronic;
  bool? fatigue;
  bool? allergy;
  bool? wheezing;
  bool? alcoholConsuming;
  bool? coughing;
  bool? shortnessOfBreath;
  bool? swallowingDifficulty;
  bool? chestPain;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Deteksi Risiko Kanker")),
      bottomNavigationBar: buildBottomNav(1, context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Lanjutkan Pengisian", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            buildQuestion(
              "Apakah Anda seorang perokok pasif?",
              passiveSmoker,
              (val) => setState(() => passiveSmoker = val),
            ),
            buildQuestion(
              "Apakah jari Anda berwarna kuning?",
              yellowFingers,
              (val) => setState(() => yellowFingers = val),
            ),
            buildQuestion(
              "Apakah Anda sering mengalami kecemasan?",
              anxiety,
              (val) => setState(() => anxiety = val),
            ),
            buildQuestion(
              "Apakah Anda mengalami tekanan dari teman sebaya?",
              peerPressure,
              (val) => setState(() => peerPressure = val),
            ),
            buildQuestion(
              "Apakah Anda memiliki penyakit kronis?",
              chronic,
              (val) => setState(() => chronic = val),
            ),
            buildQuestion(
              "Apakah Anda sering merasa lelah?",
              fatigue,
              (val) => setState(() => fatigue = val),
            ),
            buildQuestion(
              "Apakah Anda memiliki alergi?",
              allergy,
              (val) => setState(() => allergy = val),
            ),
            buildQuestion(
              "Apakah Anda mengalami mengi?",
              wheezing,
              (val) => setState(() => wheezing = val),
            ),
            buildQuestion(
              "Apakah Anda mengonsumsi alkohol?",
              alcoholConsuming,
              (val) => setState(() => alcoholConsuming = val),
            ),
            buildQuestion(
              "Apakah Anda sering batuk?",
              coughing,
              (val) => setState(() => coughing = val),
            ),
            buildQuestion(
              "Apakah Anda mengalami sesak napas?",
              shortnessOfBreath,
              (val) => setState(() => shortnessOfBreath = val),
            ),
            buildQuestion(
              "Apakah Anda mengalami kesulitan menelan?",
              swallowingDifficulty,
              (val) => setState(() => swallowingDifficulty = val),
            ),
            buildQuestion(
              "Apakah Anda mengalami nyeri dada?",
              chestPain,
              (val) => setState(() => chestPain = val),
            ),
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

  Widget buildQuestion(
    String text,
    bool? selectedValue,
    Function(bool) onChanged,
  ) {
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedValue == true ? Colors.blue : null,
                ),
                child: const Text("Iya"),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton(
                onPressed: () => onChanged(false),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: selectedValue == false ? Colors.blue : Colors.grey,
                  ),
                ),
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
    if (passiveSmoker == null ||
        yellowFingers == null ||
        anxiety == null ||
        peerPressure == null ||
        chronic == null ||
        fatigue == null ||
        allergy == null ||
        wheezing == null ||
        alcoholConsuming == null ||
        coughing == null ||
        shortnessOfBreath == null ||
        swallowingDifficulty == null ||
        chestPain == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua pertanyaan harus dijawab!")),
      );
      return;
    }

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    final data = {
      "GENDER": widget.gender == "Laki-Laki" ? 1 : 0,
      "AGE": widget.age,
      "SMOKING": passiveSmoker! ? 1 : 0,
      "YELLOW_FINGERS": yellowFingers! ? 1 : 0,
      "ANXIETY": anxiety! ? 1 : 0,
      "PEER_PRESSURE": peerPressure! ? 1 : 0,
      "CHRONIC DISEASE": chronic! ? 1 : 0,
      "FATIGUE ": fatigue! ? 1 : 0,
      "ALLERGY ": allergy! ? 1 : 0,
      "WHEEZING": wheezing! ? 1 : 0,
      "ALCOHOL CONSUMING": alcoholConsuming! ? 1 : 0,
      "COUGHING": coughing! ? 1 : 0,
      "SHORTNESS OF BREATH": shortnessOfBreath! ? 1 : 0,
      "SWALLOWING DIFFICULTY": swallowingDifficulty! ? 1 : 0,
      "CHEST PAIN": chestPain! ? 1 : 0,
    };

    try {
      final hasil = await ApiService.predictRisk(data);

      // Close loading dialog
      if (context.mounted) {
        Navigator.pop(context);
      }

      // Show result dialog
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                "Hasil Prediksi",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color:
                          hasil['prediction'].contains('Negatif')
                              ? Colors.green[50]
                              : Colors.red[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          hasil['prediction'],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color:
                                hasil['prediction'].contains('Negatif')
                                    ? Colors.green[700]
                                    : Colors.red[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Tingkat Kepercayaan: ${hasil['confidence']}%",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Saran:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "• Tetap jaga pola hidup sehat\n"
                    "• Lakukan pemeriksaan rutin\n"
                    "• Hindari faktor risiko\n"
                    "• Konsultasi dengan dokter jika diperlukan",
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => ResultPage(
                              riskResult:
                                  "${hasil['prediction']}\nTingkat Kepercayaan: ${hasil['confidence']}%",
                            ),
                      ),
                    );
                  },
                  child: const Text("Lihat Detail"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                  },
                  child: const Text("Tutup"),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Close loading dialog if it's still showing
      if (context.mounted) {
        Navigator.pop(context);
      }

      // Show error dialog
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text("Gagal memproses data: $e"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      }
    }
  }
}

Widget buildBottomNav(int selectedIndex, BuildContext context) {
  return BottomNavigationBar(
    currentIndex: selectedIndex,
    onTap: (index) {
      if (index == 0) {
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    },
    items: const [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      BottomNavigationBarItem(icon: Icon(Icons.analytics), label: "Prediction"),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
    ],
  );
}
