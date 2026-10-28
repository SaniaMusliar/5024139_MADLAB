import 'package:flutter/material.dart';

void main() => runApp(const FormApp());

class FormApp extends StatelessWidget {
  const FormApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Student Registration',
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
        home: const RegistrationForm(),
      );
}

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});
  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  String? _branch;
  String? _year;

  static const _branches = ['IT', 'Computer', 'EXTC', 'Mechanical'];
  static const _years = ['FE', 'SE', 'TE', 'BE'];

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration successful: ${_name.text} ($_branch, $_year)')),
      );
    }
  }

  void _reset() {
    _formKey.currentState!.reset();
    _name.clear();
    _email.clear();
    _phone.clear();
    setState(() {
      _branch = null;
      _year = null;
    });
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Student Registration'), centerTitle: true),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(children: [
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(
                    labelText: 'Full Name', prefixIcon: Icon(Icons.person), border: OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter your name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    labelText: 'Email', prefixIcon: Icon(Icons.email), border: OutlineInputBorder()),
                validator: (v) =>
                    (v == null || !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v)) ? 'Enter a valid email' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                    labelText: 'Phone', prefixIcon: Icon(Icons.phone), border: OutlineInputBorder()),
                validator: (v) =>
                    (v == null || !RegExp(r'^\d{10}$').hasMatch(v)) ? 'Enter a 10-digit number' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _branch,
                decoration: const InputDecoration(labelText: 'Branch', border: OutlineInputBorder()),
                items: _branches.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
                onChanged: (v) => setState(() => _branch = v),
                validator: (v) => v == null ? 'Select a branch' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _year,
                decoration: const InputDecoration(labelText: 'Year', border: OutlineInputBorder()),
                items: _years.map((y) => DropdownMenuItem(value: y, child: Text(y))).toList(),
                onChanged: (v) => setState(() => _year = v),
                validator: (v) => v == null ? 'Select a year' : null,
              ),
              const SizedBox(height: 24),
              Row(children: [
                Expanded(child: ElevatedButton(onPressed: _submit, child: const Text('Submit'))),
                const SizedBox(width: 12),
                Expanded(child: OutlinedButton(onPressed: _reset, child: const Text('Reset'))),
              ]),
            ]),
          ),
        ),
      );
}
