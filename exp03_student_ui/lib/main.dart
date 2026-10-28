
import 'package:flutter/material.dart';

void main() {
  runApp(const WidgetsApp());
}

class WidgetsApp extends StatelessWidget {
  const WidgetsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Common Widgets')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome to Flutter',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text('Text widget example'),
              const SizedBox(height: 16),
              const Icon(Icons.flutter_dash, size: 60,
                  color: Colors.blue),
              const SizedBox(height: 16),
              Image.network(
                'https://picsum.photos/400/180',
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16),
              const Card(
                child: ListTile(
                  leading: Icon(Icons.school),
                  title: Text('Student'),
                  subtitle: Text('Learning Flutter widgets'),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Click Me'),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.home),
                  Icon(Icons.search),
                  Icon(Icons.settings),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
