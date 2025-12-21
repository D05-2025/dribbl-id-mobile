import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class PlayerFormPage extends StatefulWidget {
  const PlayerFormPage({super.key});

  @override
  State<PlayerFormPage> createState() => _PlayerFormPageState();
}

class _PlayerFormPageState extends State<PlayerFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  String _team = "";
  String _position = "";
  int _pointsPerGame = 0;
  int _assistsPerGame = 0;
  int _reboundsPerGame = 0;

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Form Tambah Player')),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(
                  label: "Name",
                  onChanged: (String? value) {
                    setState(() {
                      _name = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Name cannot be empty!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: "Team",
                  onChanged: (String? value) {
                    setState(() {
                      _team = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Team cannot be empty!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: "Position",
                  onChanged: (String? value) {
                    setState(() {
                      _position = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Position cannot be empty!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: "PTS",
                  keyboardType: TextInputType.number,
                  onChanged: (String? value) {
                    setState(() {
                      _pointsPerGame = int.tryParse(value!) ?? 0;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "PTS cannot be empty!";
                    }
                    if (int.tryParse(value) == null) {
                      return "PTS must be a number (integer)!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: "AST",
                  keyboardType: TextInputType.number,
                  onChanged: (String? value) {
                    setState(() {
                      _assistsPerGame = int.tryParse(value!) ?? 0;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "AST cannot be empty!";
                    }
                    if (int.tryParse(value) == null) {
                      return "AST must be a number (integer)!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: "REB",
                  keyboardType: TextInputType.number,
                  onChanged: (String? value) {
                    setState(() {
                      _reboundsPerGame = int.tryParse(value!) ?? 0;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "REB cannot be empty!";
                    }
                    if (int.tryParse(value) == null) {
                      return "REB must be a number (integer)!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[800],
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 16,
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final response = await request.postJson(
                            "http://febrian-abimanyu-dribbl-id.pbp.cs.ui.ac.id/players/create-flutter/",
                            jsonEncode(<String, dynamic>{
                              'name': _name,
                              'team': _team,
                              'position': _position,
                              'points_per_game': _pointsPerGame,
                              'assists_per_game': _assistsPerGame,
                              'rebounds_per_game': _reboundsPerGame,
                            }),
                          );
                          if (context.mounted) {
                            if (response['status'] == 'success') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Player saved successfully!"),
                                ),
                              );
                              Navigator.pop(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Failed to save player. Please try again.",
                                  ),
                                ),
                              );
                            }
                          }
                        }
                      },
                      child: const Text(
                        "Save",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required Function(String?) onChanged,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[900],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey[800]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.orange),
        ),
      ),
      onChanged: onChanged,
      validator: validator,
      keyboardType: keyboardType,
    );
  }
}
