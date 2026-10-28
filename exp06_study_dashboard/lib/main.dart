
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(const ExploreApp());
}

class ExploreApp extends StatelessWidget {
  const ExploreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
      ),
      home: const ExploreHome(),
    );
  }
}

class ExploreHome extends StatelessWidget {
  const ExploreHome({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'icon': Icons.flight_takeoff, 'title': 'Flights'},
      {'icon': Icons.hotel_outlined, 'title': 'Hotels'},
      {'icon': Icons.restaurant_outlined, 'title': 'Food'},
      {'icon': Icons.map_outlined, 'title': 'Places'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Explore'),
            Text(
              'Discover your next adventure',
              style: TextStyle(fontSize: 13),
            ),
          ],
        ),
        actions: const [
          Icon(Icons.notifications_none_rounded),
          SizedBox(width: 16),
          CircleAvatar(child: Icon(Icons.person_outline)),
          SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Image.network(
                'https://images.unsplash.com/photo-1500534623283-312aade485b7?auto=format&fit=crop&w=1000&q=80',
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(
                  height: 180,
                  color: Colors.indigo.shade100,
                  child: const Center(
                    child: Icon(Icons.landscape, size: 60),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Quick Explore',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Row(
              children: categories.map((item) {
                return Expanded(
                  child: Container(
                    height: 105,
                    margin: const EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          item['icon'] as IconData,
                          size: 28,
                          color: Colors.indigo,
                        ),
                        const SizedBox(height: 8),
                        Text(item['title'] as String),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 25),
            const Text(
              'Weekly Visitors',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 220,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 10,
                  barGroups: [
                    _bar(0, 4),
                    _bar(1, 7),
                    _bar(2, 5),
                    _bar(3, 8),
                    _bar(4, 6),
                    _bar(5, 9),
                    _bar(6, 7),
                  ],
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const days = [
                            'M', 'T', 'W', 'T', 'F', 'S', 'S'
                          ];
                          final index = value.toInt();
                          if (index < 0 || index >= days.length) {
                            return const SizedBox.shrink();
                          }
                          return Text(days[index]);
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: const FlGridData(show: true),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static BarChartGroupData _bar(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          width: 16,
          borderRadius: BorderRadius.circular(4),
          color: Colors.indigo,
        ),
      ],
    );
  }
}
