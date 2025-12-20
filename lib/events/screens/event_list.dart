import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

import '../models/event.dart';
import '../widgets/event_card.dart';
import 'event_details.dart';
import 'event_form.dart';

class EventListPage extends StatefulWidget {
  const EventListPage({super.key});

  @override
  State<EventListPage> createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  // --- style seragam ---
  static const TextStyle _topBarTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );

  // --- state search/sort/filter ---
  String _searchQuery = "";
  String _filterOption = "all"; // all, upcoming, past
  bool _sortAsc = true;

  void openDetail(Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EventDetailsPage(event: event),
      ),
    );
  }

  void navigateToEdit(Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EventFormPage(event: event),
      ),
    ).then((value) {
      if (value == true) setState(() {});
    });
  }

  void deleteEvent(int id) async {
    final request = context.read<CookieRequest>();

    try {
      final response = await request.post(
        "https://febrian-abimanyu-dribbl-id.pbp.cs.ui.ac.id/events/delete-flutter/",
        {"id": id.toString()},
      );

      if (!mounted) return;

      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Event berhasil dihapus!"),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? "Gagal menghapus event"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void showDeleteConfirmation(Event event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Event"),
        content: Text(
          "Yakin ingin menghapus event '${event.title}'?\n\nTindakan ini tidak dapat dibatalkan.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              deleteEvent(event.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
  }

  Future<List<Event>> fetchEvents(CookieRequest request) async {
    final response = await request.get("https://febrian-abimanyu-dribbl-id.pbp.cs.ui.ac.id/events/json/");
    return response.map<Event>((e) => Event.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final role = request.jsonData["role"];
    final isAdmin = role == 'admin';

    // ====== cek lebar layar, kalau kecil pakai mode ikon ======
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isCompact = screenWidth < 430; // 👈 dinaikkan, 400px sudah ikon-only

    // daftar item dropdown filter (dipakai di 2 mode: normal & compact)
    final filterItems = [
      DropdownMenuItem(
        value: "all",
        child: Text("Semua Event", style: _topBarTextStyle),
      ),
      DropdownMenuItem(
        value: "upcoming",
        child: Text("Event Mendatang", style: _topBarTextStyle),
      ),
      DropdownMenuItem(
        value: "past",
        child: Text("Event Berlalu", style: _topBarTextStyle),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        leadingWidth: 140,
        centerTitle: true,
        backgroundColor: Colors.grey[900],
        elevation: 0,
        title: const Text(
          "Event List",
          style: TextStyle(fontSize: 20),
        ),
        leading: Row(
          children: [
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isAdmin ? "ADMIN" : "REGULAR USER",
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: isAdmin
          ? FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const EventFormPage(),
            ),
          ).then((value) {
            if (value == true) setState(() {});
          });
        },
        child: const Icon(Icons.add, color: Colors.white),
      )
          : null,

      body: Column(
        children: [
          // ================= TOP SEARCH + FILTER + SORT =================
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
            child: Row(
              children: [
                // SEARCH BOX
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 40,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
                    decoration: BoxDecoration(
                      color: Colors.grey[850],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      style: _topBarTextStyle,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        isDense: true, // biar lebih rapat dan ketengah
                        hintText: "Cari event atau lokasi...",
                        hintStyle: _topBarTextStyle.copyWith(
                          color: Colors.white,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.white, // samain juga ikon search-nya
                        ),
                        prefixIconConstraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, // Penyesuaian vertical
                        ),
                      ),
                      onChanged: (value) {
                        setState(() => _searchQuery = value);
                      },
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // FILTER + SORT
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      // ================= FILTER =================
                      Expanded(
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 1),
                          decoration: BoxDecoration(
                            color: Colors.grey[850],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: isCompact
                            // ===== mode compact: cuma ikon filter =====
                                ? DropdownButton<String>(
                              value: _filterOption,
                              dropdownColor: Colors.grey[900],
                              icon: const Icon(
                                Icons.filter_list,
                                color: Colors.white,
                              ),
                              style: _topBarTextStyle,
                              items: filterItems,
                              // hide selected text, cuma ikon yang kelihatan
                              selectedItemBuilder: (context) =>
                                  filterItems
                                      .map((_) =>
                                  const SizedBox.shrink())
                                      .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() => _filterOption = value);
                                }
                              },
                            )
                            // ===== mode normal: teks + arrow =====
                                : DropdownButton<String>(
                              isDense: true,
                              isExpanded:
                              true, // 👈 biar muat di lebar kontainer
                              value: _filterOption,
                              dropdownColor: Colors.grey[900],
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white,
                              ),
                              style: _topBarTextStyle,
                              items: filterItems,
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() => _filterOption = value);
                                }
                              },
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 6),

                      // ================= SORT =================
                      Expanded(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            setState(() => _sortAsc = !_sortAsc);
                          },
                          child: Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 1),
                            decoration: BoxDecoration(
                              color: Colors.grey[850],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: isCompact
                            // ===== mode compact: cuma ikon panah =====
                                ? Center(
                              child: Icon(
                                _sortAsc
                                    ? Icons.arrow_downward
                                    : Icons.arrow_upward,
                                color: Colors.white,
                                size: 18,
                              ),
                            )
                            // ===== mode normal: teks + ikon =====
                                : Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded( // 👈 kasih flex biar gak overflow
                                  child: Text(
                                    _sortAsc
                                        ? "Terdekat dulu"
                                        : "Terjauh dulu",
                                    style: _topBarTextStyle,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  _sortAsc
                                      ? Icons.arrow_downward
                                      : Icons.arrow_upward,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ================= EVENT LIST =================
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                setState(() {});
              },
              child: FutureBuilder(
                future: fetchEvents(request),
                builder: (context, AsyncSnapshot<List<Event>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListView(
                      children: const [
                        SizedBox(height: 260),
                        Center(child: CircularProgressIndicator()),
                      ],
                    );
                  }

                  if (snapshot.hasError) {
                    return ListView(
                      children: [
                        const SizedBox(height: 160),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline,
                                  size: 64, color: Colors.red),
                              const SizedBox(height: 16),
                              Text(
                                "Error: ${snapshot.error}",
                                style: const TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => setState(() {}),
                                child: const Text("Retry"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return ListView(
                      children: const [
                        SizedBox(height: 160),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.event_busy,
                                  size: 64, color: Colors.grey),
                              SizedBox(height: 16),
                              Text(
                                "Tidak ada event ditemukan.",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }

                  final allEvents = snapshot.data!;
                  final now = DateTime.now();

                  final filteredEvents = allEvents.where((event) {
                    final q = _searchQuery.toLowerCase();

                    final matchesSearch = q.isEmpty ||
                        event.title.toLowerCase().contains(q) ||
                        event.location.toLowerCase().contains(q);

                    if (!matchesSearch) return false;

                    final eventDate = DateTime(
                      event.date.year,
                      event.date.month,
                      event.date.day,
                    );
                    final today =
                    DateTime(now.year, now.month, now.day);

                    if (_filterOption == "upcoming") {
                      return eventDate.isAtSameMomentAs(today) ||
                          eventDate.isAfter(today);
                    } else if (_filterOption == "past") {
                      return eventDate.isBefore(today);
                    }
                    return true;
                  }).toList();

                  filteredEvents.sort((a, b) {
                    final ad =
                    DateTime(a.date.year, a.date.month, a.date.day);
                    final bd =
                    DateTime(b.date.year, b.date.month, b.date.day);
                    return _sortAsc ? ad.compareTo(bd) : bd.compareTo(ad);
                  });

                  if (filteredEvents.isEmpty) {
                    return ListView(
                      children: const [
                        SizedBox(height: 160),
                        Center(
                          child: Text(
                            "Tidak ada event yang cocok dengan pencarian / filter.",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredEvents.length,
                    itemBuilder: (_, index) {
                      final event = filteredEvents[index];

                      return EventCard(
                        event: event,
                        onTap: () => openDetail(event),
                        onEdit: isAdmin ? () => navigateToEdit(event) : null,
                        onDelete:
                        isAdmin ? () => showDeleteConfirmation(event) : null,
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
