import 'package:flutter/material.dart';
import 'package:dribbl_id/events/models/event.dart';

class EventCard extends StatefulWidget {
  final Event event;
  final VoidCallback onTap;

  const EventCard({super.key, required this.event, required this.onTap});

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth > 900 ? 900.0 : screenWidth * 0.95;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()..scale(isHovered ? 1.015 : 1.0),
        margin: const EdgeInsets.symmetric(vertical: 18),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Center(
            child: Container(
              width: cardWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF1A1A1A),
                    Color(0xFF0F0F0F),
                    Color(0xFF0A0A0A),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isHovered ? 0.55 : 0.35),
                    blurRadius: isHovered ? 26 : 16,
                    offset: const Offset(0, 8),
                  ),
                ],
                border: Border.all(color: Colors.grey.shade800),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Stack(
                  children: [
                    // MAIN CONTENT
                    Row(
                      children: [
                        // LEFT SIDE (text)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(22),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // BADGE
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: widget.event.isPublic
                                        ? Colors.greenAccent.shade700
                                        : Colors.orange.shade700,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    widget.event.isPublic
                                        ? "Public"
                                        : "Private",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 16),

                                Text(
                                  widget.event.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    height: 1.1,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                if (widget.event.description != null &&
                                    widget.event.description!.trim().isNotEmpty)
                                  Text(
                                    widget.event.description!,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.grey.shade300,
                                      fontSize: 15,
                                      height: 1.4,
                                    ),
                                  ),

                                const SizedBox(height: 20),

                                Row(
                                  children: [
                                    Icon(Icons.location_on_outlined,
                                        size: 18,
                                        color: Colors.grey.shade400),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        widget.event.location,
                                        style: TextStyle(
                                          color: Colors.grey.shade300,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 10),

                                Row(
                                  children: [
                                    Icon(Icons.calendar_month_outlined,
                                        size: 18,
                                        color: Colors.grey.shade400),
                                    const SizedBox(width: 8),
                                    Text(
                                      "${widget.event.date.toLocal()}"
                                          .split(" ")[0],
                                      style: TextStyle(
                                          color: Colors.grey.shade300,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 10),

                                Row(
                                  children: [
                                    Icon(Icons.access_time_outlined,
                                        size: 18,
                                        color: Colors.grey.shade400),
                                    const SizedBox(width: 8),
                                    Text(
                                      widget.event.time,
                                      style: TextStyle(
                                          color: Colors.grey.shade300,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 22),

                                ElevatedButton(
                                  onPressed: widget.onTap,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey.shade700,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: const Text(
                                    "Lihat Detail",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),

                        // RIGHT IMAGE
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(22),
                            bottomRight: Radius.circular(22),
                          ),
                          child: widget.event.imageUrl.isNotEmpty
                              ? Image.network(
                            widget.event.imageUrl,
                            width: 260,
                            height: 220,
                            fit: BoxFit.cover,
                          )
                              : Container(
                            width: 260,
                            height: 220,
                            color: Colors.grey.shade800,
                            child: const Icon(Icons.image,
                                color: Colors.white30, size: 40),
                          ),
                        ),
                      ],
                    ),

                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 1200),
                      curve: Curves.easeOutCubic,
                      left: isHovered ? cardWidth * 1.1 : -200,
                      top: -20,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 5000),
                        opacity: isHovered ? 0.5 : 0.0,
                        child: Transform.rotate(
                          angle: -0.30, // miring biar cinematic
                          child: Container(
                            width: 160,
                            height: 260,  // tidak full height biar natural
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.white.withOpacity(0.0),
                                  Colors.white.withOpacity(0.25),
                                  Colors.white.withOpacity(0.05),
                                  Colors.white.withOpacity(0.0),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
