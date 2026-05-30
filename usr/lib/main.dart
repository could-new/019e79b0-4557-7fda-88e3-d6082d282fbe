import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Penggabung Nama',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const NameCombinerScreen(),
      },
    );
  }
}

class NameCombinerScreen extends StatefulWidget {
  const NameCombinerScreen({super.key});

  @override
  State<NameCombinerScreen> createState() => _NameCombinerScreenState();
}

class _NameCombinerScreenState extends State<NameCombinerScreen> {
  final TextEditingController _name1Controller = TextEditingController();
  final TextEditingController _name2Controller = TextEditingController();
  List<String> _combinations = [];

  void _generateCombinations() {
    FocusScope.of(context).unfocus();
    String n1 = _name1Controller.text.trim();
    String n2 = _name2Controller.text.trim();

    if (n1.isEmpty || n2.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan masukkan kedua nama')),
      );
      return;
    }

    Set<String> results = {};
    
    // Combine first half of n1 and second half of n2
    int half1 = (n1.length / 2).ceil();
    int half2 = (n2.length / 2).ceil();
    
    String part1A = n1.substring(0, half1);
    String part1B = n1.substring(half1);
    String part2A = n2.substring(0, half2);
    String part2B = n2.substring(half2);

    results.add('$part1A$part2B');
    results.add('$part2A$part1B');
    results.add('$part1A$part2A');
    results.add('$part1B$part2B');
    
    // Alternate combinations
    results.add('$n1 $n2');
    results.add('$n2 $n1');
    
    // Simple mixing
    results.add('${n1.substring(0, 1).toUpperCase()}${n2.substring(1)}');
    results.add('${n2.substring(0, 1).toUpperCase()}${n1.substring(1)}');
    
    // Convert all to proper case
    List<String> formattedResults = results.map((name) {
      if (name.isEmpty) return name;
      return name.split(' ').map((word) {
        if (word.isEmpty) return word;
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      }).join(' ');
    }).toList();

    setState(() {
      _combinations = formattedResults;
    });
  }

  @override
  void dispose() {
    _name1Controller.dispose();
    _name2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Penggabung Nama'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _name1Controller,
                        decoration: const InputDecoration(
                          labelText: 'Nama Pertama',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _name2Controller,
                        decoration: const InputDecoration(
                          labelText: 'Nama Kedua',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _generateCombinations,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Gabungkan Nama', style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(),
            Expanded(
              child: _combinations.isEmpty
                  ? const Center(
                      child: Text('Kombinasi nama akan muncul di sini'),
                    )
                  : ListView.builder(
                      itemCount: _combinations.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: CircleAvatar(
                            child: Text('${index + 1}'),
                          ),
                          title: Text(
                            _combinations[index],
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
