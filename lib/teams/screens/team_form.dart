import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:dribbl_id/teams/screens/team_page.dart';

class TeamFormPage extends StatefulWidget {
  const TeamFormPage({super.key});

  @override
  State<TeamFormPage> createState() => _TeamFormPageState();
}

class _TeamFormPageState extends State<TeamFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Variables
  String _name = "";
  String _logo = "";
  String _region = "United States"; // Default value
  DateTime? _founded;
  String _description = "";

  final TextEditingController _dateController = TextEditingController();

  // List Region (Bisa disesuaikan)
  final List<String> _regions = [
    'United States',
    'Canada',
    'Europe',
    'Asia',
    'Australia',
    'Other'
  ];

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Add a New Team", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Name Input ---
              _buildLabel("Name"),
              _buildTextField(
                hint: 'Team Name (e.g., "LA Lakers")',
                onChanged: (val) => _name = val,
              ),
              const SizedBox(height: 20),

              // --- Logo Input ---
              _buildLabel("Logo URL"),
              _buildTextField(
                hint: 'https://example.com/logo.png',
                onChanged: (val) => _logo = val,
              ),
              const SizedBox(height: 20),

              // --- Region Dropdown ---
              _buildLabel("Region"),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1E), // Input Background Dark
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white24),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _region,
                    dropdownColor: const Color(0xFF1C1C1E),
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
                    style: const TextStyle(color: Colors.white),
                    items: _regions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _region = newValue!;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // --- Founded Date Picker ---
              _buildLabel("Founded"),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration(hint: "dd/mm/yyyy").copyWith(
                  suffixIcon: const Icon(Icons.calendar_today, color: Colors.white54),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.dark(
                            primary: Colors.blueAccent,
                            onPrimary: Colors.white,
                            surface: Color(0xFF1C1C1E),
                            onSurface: Colors.white,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _founded = pickedDate;
                      _dateController.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please select a date";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // --- Description Input ---
              _buildLabel("Description"),
              _buildTextField(
                hint: "A brief description of the team...",
                maxLines: 5,
                onChanged: (val) => _description = val,
              ),
              const SizedBox(height: 40),

              // --- Save Button ---
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Kirim data ke Django
                      // TODO: Pastikan endpoint URL ini benar sesuai `urls.py` di Django kamu
                      final response = await request.postJson(
                        "http://localhost:8000/teams/create-flutter/", 
                        jsonEncode({
                          "name": _name,
                          "logo": _logo,
                          "region": _region,
                          "founded": _founded != null 
                              ? "${_founded!.year}-${_founded!.month.toString().padLeft(2,'0')}-${_founded!.day.toString().padLeft(2,'0')}" 
                              : "",
                          "description": _description,
                        }),
                      );

                      if (context.mounted) {
                        if (response['status'] == 'success') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Team saved successfully!")),
                          );
                          // Kembali ke list dan refresh (biasanya pushReplacement ke page utama)
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const TeamsPage()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Failed to save team. Please try again.")),
                          );
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Save Team", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widgets untuk Styling
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }

  Widget _buildTextField({
    required String hint, 
    required Function(String) onChanged, 
    int maxLines = 1
  }) {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      maxLines: maxLines,
      decoration: _inputDecoration(hint: hint),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "This field cannot be empty";
        }
        return null;
      },
    );
  }

  InputDecoration _inputDecoration({required String hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[600]),
      filled: true,
      fillColor: const Color(0xFF1C1C1E), // Warna input background gelap
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.white24),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.white24),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.blueAccent),
      ),
    );
  }
}