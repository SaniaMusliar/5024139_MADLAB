import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const StudentApp());
}

class StudentApp extends StatelessWidget {
  const StudentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Attendance',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        scaffoldBackgroundColor: const Color(0xffF7F9FC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff6366F1),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int page = 0;

  final pages = const [
    DashboardPage(),
    StudentsPage(),
    ReportsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[page],
      bottomNavigationBar: NavigationBar(
        selectedIndex: page,
        onDestinationSelected: (i) {
          setState(() => page = i);
        },
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xffE8E8FF),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Students',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Reports',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// ================= DASHBOARD =================

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('students')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final docs = snapshot.data?.docs ?? [];

          final present = docs.where((d) {
            final status =
                (d.data() as Map<String, dynamic>)['status']
                    ?.toString()
                    .trim()
                    .toLowerCase();
            return status == 'present';
          }).length;

          final absent = docs.where((d) {
            final status =
                (d.data() as Map<String, dynamic>)['status']
                    ?.toString()
                    .trim()
                    .toLowerCase();
            return status == 'absent';
          }).length;

          final total = present + absent;

          final percentage = total == 0
              ? 0
              : ((present / total) * 100).round();

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: Color(0xffE8E8FF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Color(0xff5B5FEF),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sania Musliar',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'B.Tech IT • 5024139',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.notifications_none,
                        size: 22,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                const Text(
                  'Good evening, Sania',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  'Here is your attendance overview',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 22),

                // ATTENDANCE
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 22,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xff6366F1),
                        Color(0xff7C83F5),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 82,
                        height: 82,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 78,
                              height: 78,
                              child: CircularProgressIndicator(
                                value: percentage / 100,
                                strokeWidth: 7,
                                backgroundColor: Colors.white24,
                                valueColor:
                                    const AlwaysStoppedAnimation(
                                  Colors.white,
                                ),
                              ),
                            ),
                            Text(
                              '$percentage%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Expanded(
                        child: Text(
                          'Overall Attendance',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // STATISTICS
                Row(
                  children: [
                    Expanded(
                      child: statBox(
                        'Students',
                        '$total',
                        Icons.people_outline,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: statBox(
                        'Present',
                        '$present',
                        Icons.check_circle_outline,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: statBox(
                        'Absent',
                        '$absent',
                        Icons.cancel_outlined,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // QUICK ACTIONS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('View all'),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: actionButton(
                        context,
                        Icons.person_add_alt_1,
                        'Add Student',
                        const AddStudentPage(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: actionButton(
                        context,
                        Icons.fact_check_outlined,
                        'Attendance',
                        const StudentsPage(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: actionButton(
                        context,
                        Icons.analytics_outlined,
                        'Reports',
                        const ReportsPage(),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // STUDENTS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Students',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const StudentsPage(),
                          ),
                        );
                      },
                      child: const Text('See all'),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                if (docs.isEmpty)
                  emptyStudents()
                else
                  ...docs.take(4).map(
                    (doc) => studentRow(context, doc),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ================= STUDENTS =================

class StudentsPage extends StatefulWidget {
  const StudentsPage({super.key});

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  String search = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('students')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final students = snapshot.data!.docs.where((doc) {
            final name = doc['name'].toString().toLowerCase();
            final roll = doc['rollNo'].toString().toLowerCase();

            return name.contains(search.toLowerCase()) ||
                roll.contains(search.toLowerCase());
          }).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 4),
                child: Text(
                  'Students',
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Manage student attendance',
                  style: TextStyle(color: Colors.grey),
                ),
              ),

              const SizedBox(height: 18),

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  onChanged: (value) {
                    setState(() => search = value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search students...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              Expanded(
                child: students.isEmpty
                    ? emptyStudents()
                    : ListView.builder(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: students.length,
                        itemBuilder: (context, index) {
                          return studentRow(
                            context,
                            students[index],
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ================= REPORTS =================

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('students')
            .snapshots(),
        builder: (context, snapshot) {
          final docs = snapshot.data?.docs ?? [];

          final present = docs.where((d) {
            final status =
                (d.data() as Map<String, dynamic>)['status']
                    ?.toString()
                    .trim()
                    .toLowerCase();

            return status == 'present';
          }).length;

          final absent = docs.where((d) {
            final status =
                (d.data() as Map<String, dynamic>)['status']
                    ?.toString()
                    .trim()
                    .toLowerCase();

            return status == 'absent';
          }).length;

          final total = present + absent;

          final percentage = total == 0
              ? 0
              : ((present / total) * 100).round();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Attendance Report',
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  'Attendance statistics',
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 30),

                Center(
                  child: SizedBox(
                    width: 190,
                    height: 190,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 170,
                          height: 170,
                          child: CircularProgressIndicator(
                            value: percentage / 100,
                            strokeWidth: 15,
                            backgroundColor:
                                const Color(0xffE7E9F2),
                            valueColor:
                                const AlwaysStoppedAnimation(
                              Color(0xff6366F1),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$percentage%',
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'Attendance',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                reportRow(
                  Icons.people,
                  'Total Students',
                  '$total',
                ),

                reportRow(
                  Icons.check_circle,
                  'Present',
                  '$present',
                ),

                reportRow(
                  Icons.cancel,
                  'Absent',
                  '$absent',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ================= PROFILE =================

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            const SizedBox(height: 25),

            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: Color(0xffE8E8FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                size: 55,
                color: Color(0xff5B5FEF),
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              'Sania Musliar',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              'B.Tech Information Technology',
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 30),

            profileItem(
              Icons.badge_outlined,
              'Roll Number',
              '5024139',
            ),

            profileItem(
              Icons.school_outlined,
              'College',
              'FCRIT, Vashi',
            ),

            profileItem(
              Icons.menu_book_outlined,
              'Semester',
              'V',
            ),

            profileItem(
              Icons.cloud_outlined,
              'Database',
              'Firebase Firestore',
            ),
          ],
        ),
      ),
    );
  }
}

// ================= ADD STUDENT =================

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({super.key});

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final rollController = TextEditingController();
  final courseController = TextEditingController();

  String status = 'Present';
  bool loading = false;

  Future<void> saveStudent() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => loading = true);

    await FirebaseFirestore.instance.collection('students').add({
      'name': nameController.text.trim(),
      'rollNo': rollController.text.trim(),
      'course': courseController.text.trim(),
      'status': status,
    });

    if (!mounted) return;

    setState(() => loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Student added successfully'),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Student'),
        backgroundColor: Colors.transparent,
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(22),
          children: [
            const Text(
              'Student Details',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Enter student information',
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 25),

            input(
              controller: nameController,
              label: 'Student Name',
              icon: Icons.person_outline,
            ),

            input(
              controller: rollController,
              label: 'Roll Number',
              icon: Icons.badge_outlined,
            ),

            input(
              controller: courseController,
              label: 'Course',
              icon: Icons.school_outlined,
            ),

            DropdownButtonFormField<String>(
              value: status,
              decoration: InputDecoration(
                labelText: 'Attendance Status',
                prefixIcon:
                    const Icon(Icons.fact_check_outlined),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Present',
                  child: Text('Present'),
                ),
                DropdownMenuItem(
                  value: 'Absent',
                  child: Text('Absent'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => status = value);
                }
              },
            ),

            const SizedBox(height: 28),

            SizedBox(
              height: 55,
              child: ElevatedButton.icon(
                onPressed: loading ? null : saveStudent,
                icon: const Icon(
                  Icons.cloud_upload_outlined,
                ),
                label: Text(
                  loading ? 'Saving...' : 'Save Student',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget input({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

// ================= STUDENT DETAILS =================

class StudentDetails extends StatelessWidget {
  final DocumentSnapshot student;

  const StudentDetails({
    super.key,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    final data =
        student.data() as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Profile'),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.data_object),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Student Data'),
                  content: SingleChildScrollView(
                    child: Text(
                      const JsonEncoder.withIndent('  ')
                          .convert(data),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () =>
                          Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: const Color(0xffE8E8FF),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.person,
                size: 50,
                color: Color(0xff5B5FEF),
              ),
            ),

            const SizedBox(height: 15),

            Text(
              data['name'] ?? 'Unknown Student',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            detailItem(
              'Roll Number',
              data['rollNo'] ?? '-',
            ),

            detailItem(
              'Course',
              data['course'] ?? 'B.Tech IT',
            ),

            detailItem(
              'Attendance',
              data['status'] ?? '-',
            ),

            detailItem(
              'Document ID',
              student.id,
            ),
          ],
        ),
      ),
    );
  }
}

// ================= REUSABLE UI =================

Widget statBox(
  String title,
  String value,
  IconData icon,
) {
  return Container(
    padding: const EdgeInsets.symmetric(
      vertical: 16,
      horizontal: 8,
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Column(
      children: [
        Icon(
          icon,
          size: 21,
          color: const Color(0xff6366F1),
        ),
        const SizedBox(height: 7),
        Text(
          value,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
          ),
        ),
      ],
    ),
  );
}

Widget actionButton(
  BuildContext context,
  IconData icon,
  String title,
  Widget page,
) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => page,
        ),
      );
    },
    child: Container(
      height: 95,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: const Color(0xff6366F1),
            size: 26,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget studentRow(
  BuildContext context,
  DocumentSnapshot doc,
) {
  final data =
      doc.data() as Map<String, dynamic>;

  final name = data['name']?.toString() ?? 'Unknown';
  final roll = data['rollNo']?.toString() ?? '-';
  final status = data['status']?.toString() ?? 'Absent';

  final present =
      status.trim().toLowerCase() == 'present';

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => StudentDetails(
            student: doc,
          ),
        ),
      );
    },

    onLongPress: () {
      showModalBottomSheet(
        context: context,
        builder: (_) => SafeArea(
          child: ListTile(
            leading: const Icon(
              Icons.delete_outline,
              color: Colors.red,
            ),
            title: const Text('Delete Student'),
            onTap: () async {
              await doc.reference.delete();

              if (context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
        ),
      );
    },

    onHorizontalDragEnd: (_) async {
      await doc.reference.update({
        'status': present ? 'Absent' : 'Present',
      });
    },

    child: Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: present
                  ? const Color(0xffE5F8EE)
                  : const Color(0xffffeee8),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.person,
              color: present
                  ? const Color(0xff20A464)
                  : const Color(0xffEF6C4D),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '$roll • B.Tech IT',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 9,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: present
                  ? const Color(0xffE8F8EF)
                  : const Color(0xffffeeee),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: present
                    ? const Color(0xff19955A)
                    : const Color(0xffD94B4B),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget emptyStudents() {
  return const Center(
    child: Padding(
      padding: EdgeInsets.all(30),
      child: Column(
        children: [
          Icon(
            Icons.people_outline,
            size: 55,
            color: Colors.grey,
          ),
          SizedBox(height: 10),
          Text(
            'No students found',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget reportRow(
  IconData icon,
  String title,
  String value,
) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Row(
      children: [
        Icon(
          icon,
          color: const Color(0xff6366F1),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Text(title),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
      ],
    ),
  );
}

Widget profileItem(
  IconData icon,
  String title,
  String value,
) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(17),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Row(
      children: [
        Icon(
          icon,
          color: const Color(0xff6366F1),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget detailItem(
  String title,
  String value,
) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(17),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}