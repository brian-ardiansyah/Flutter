import 'package:flutter/material.dart';
import 'dart:convert';
// import 'package:http/http.dart' as http;

void main() {
  runApp(const CekParuApp());
}

class CekParuApp extends StatelessWidget {
  const CekParuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CekParu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/gender': (context) => const GenderScreen(),
        '/questions': (context) => const QuestionScreen(),
        '/result': (context) => const ResultScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CekParu')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/gender'),
          child: const Text('Mulai Prediksi'),
        ),
      ),
    );
  }
}

class GenderScreen extends StatefulWidget {
  const GenderScreen({super.key});

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  String? gender;
  String? age;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Deteksi Risiko Kanker')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Gender:'),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Laki-laki'),
                    value: 'Laki-laki',
                    groupValue: gender,
                    onChanged: (value) => setState(() => gender = value),
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Perempuan'),
                    value: 'Perempuan',
                    groupValue: gender,
                    onChanged: (value) => setState(() => gender = value),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Berapa Usia Kamu:'),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) => age = value,
              decoration: const InputDecoration(hintText: 'Contoh: 30'),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (gender != null && age != null) {
                    Navigator.pushNamed(
                      context,
                      '/questions',
                      arguments: {'gender': gender, 'age': age},
                    );
                  }
                },
                child: const Text('Lanjutkan'),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  bool? question1;
  bool? question2;

  Future<String> getPrediction({
    required String gender,
    required String age,
    required bool question1,
    required bool question2,
  }) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/predict'), // Ganti IP jika perlu
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'gender': gender,
        'age': int.parse(age),
        'question1': question1,
        'question2': question2,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['result'];
    } else {
      throw Exception('Gagal mendapatkan prediksi');
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final gender = args['gender'];
    final age = args['age'];

    return Scaffold(
      appBar: AppBar(title: const Text('Deteksi Risiko Kanker')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Apakah Anda sering mengalami batuk yang tidak kunjung sembuh?'),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text('Ya'),
                    value: true,
                    groupValue: question1,
                    onChanged: (value) => setState(() => question1 = value),
                  ),
                ),
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text('Tidak'),
                    value: false,
                    groupValue: question1,
                    onChanged: (value) => setState(() => question1 = value),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Apakah Anda memiliki riwayat penyakit kronis?'),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text('Ya'),
                    value: true,
                    groupValue: question2,
                    onChanged: (value) => setState(() => question2 = value),
                  ),
                ),
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text('Tidak'),
                    value: false,
                    groupValue: question2,
                    onChanged: (value) => setState(() => question2 = value),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (question1 != null && question2 != null) {
                    final result = await getPrediction(
                      gender: gender,
                      age: age,
                      question1: question1!,
                      question2: question2!,
                    );

                    Navigator.pushNamed(
                      context,
                      '/result',
                      arguments: {'result': result},
                    );
                  }
                },
                child: const Text('Cek Hasil'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final result = args['result'];

    return Scaffold(
      appBar: AppBar(title: const Text('Hasil Prediksi')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Hasil Deteksi Risiko:\nSaat ini Anda memiliki risiko $result',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'Namun tetap disarankan menjaga pola hidup sehat dan melakukan pemeriksaan rutin.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => Navigator.popUntil(context, ModalRoute.withName('/')),
                child: const Text('Selesai'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/gender'),
                child: const Text('Ulangi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
