import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:dribbl_id/events/models/event.dart';

class EventCard extends StatefulWidget {
  final Event event;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const EventCard({
    super.key,
    required this.event,
    required this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool isHovered = false;
  bool hoverActions = false;

  String get formattedDate {
    final d = widget.event.date;
    return "${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth > 900 ? 900.0 : screenWidth * 0.95;
    final isMobile = screenWidth < 600;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) {
        setState(() {
          isHovered = false;
          hoverActions = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()
          ..scale(isHovered && !isMobile ? 1.012 : 1.0),
        margin: EdgeInsets.symmetric(
          vertical: isMobile ? 12 : 18,
          horizontal: isMobile ? 12 : 0,
        ),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Center(
            child: Container(
              width: isMobile ? double.infinity : cardWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(isMobile ? 16 : 22),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF141414),
                    Color(0xFF0F0F0F),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isHovered ? 0.55 : 0.33),
                    blurRadius: isHovered ? 26 : 16,
                    offset: const Offset(0, 8),
                  ),
                ],
                border: Border.all(color: Colors.grey.shade800),
              ),

              child: ClipRRect(
                borderRadius: BorderRadius.circular(isMobile ? 16 : 22),
                child: Stack(
                  children: [
                    isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
                    if (!isMobile) _buildShineAnimation(cardWidth),
                    _buildActionButtons(isMobile),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Desktop Layout (Horizontal)
  Widget _buildDesktopLayout() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: _buildContent(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 18),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: widget.event.imageUrl.isNotEmpty
                ? Image.network(
              widget.event.imageUrl,
              width: 260,
              height: 200,
              fit: BoxFit.cover,
            )
                : Container(
              width: 260,
              height: 200,
              color: Colors.grey.shade800,
              child: const Icon(Icons.image,
                  color: Colors.white30, size: 40),
            ),
          ),
        ),
      ],
    );
  }

  // Mobile Layout (Vertical)
  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.event.imageUrl.isNotEmpty)
          Image.network(
            widget.event.imageUrl,
            height: 180,
            fit: BoxFit.cover,
          )
        else
          Container(
            height: 180,
            color: Colors.grey.shade800,
            child: const Icon(Icons.image, color: Colors.white30, size: 40),
          ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: _buildContent(isMobile: true),
        ),
      ],
    );
  }

  // Content
  Widget _buildContent({bool isMobile = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildBadge(),
            const SizedBox(width: 10),
            _buildDateBadge(),
          ],
        ),
        SizedBox(height: isMobile ? 10 : 14),
        Text(
          widget.event.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 22 : 26,
            fontWeight: FontWeight.w700,
            height: 1.05,
          ),
        ),
        SizedBox(height: isMobile ? 8 : 10),

        // description tidak null (model kamu tidak nullable)
        if (widget.event.description.isNotEmpty)
          Text(
            widget.event.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey.shade300,
              fontSize: isMobile ? 13 : 14,
              height: 1.4,
            ),
          ),

        SizedBox(height: isMobile ? 10 : 14),
        _info(Icons.location_on_outlined, widget.event.location),
        const SizedBox(height: 8),
        _info(Icons.access_time_outlined, widget.event.time),
        SizedBox(height: isMobile ? 14 : 18),
        ElevatedButton(
          onPressed: widget.onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.shade700,
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : 18,
              vertical: isMobile ? 9 : 10,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: Text(
            "Lihat Detail",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: isMobile ? 13 : 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShineAnimation(double cardWidth) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeOutExpo,
      left: isHovered ? cardWidth * 0.95 : -260,
      top: -20,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 4000),
        opacity: isHovered ? 0.45 : 0.0,
        child: Transform.rotate(
          angle: -0.35,
          child: Container(
            width: 150,
            height: 300,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(0.0),
                  Colors.white.withOpacity(0.20),
                  Colors.white.withOpacity(0.04),
                  Colors.white.withOpacity(0.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(bool isMobile) {
    return Positioned(
      top: isMobile ? 12 : 18,
      right: isMobile ? 12 : 24,
      child: MouseRegion(
        onEnter: (_) => setState(() => hoverActions = true),
        onExit: (_) => setState(() => hoverActions = false),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 220),
          opacity: isMobile ? 1 : (isHovered || hoverActions ? 1 : 0),
          child: Row(
            children: [
              if (widget.onEdit != null)
                _appleActionBtn(
                  Icons.edit_rounded,
                  onTap: widget.onEdit!,
                ),
              const SizedBox(width: 10),
              if (widget.onDelete != null)
                _appleActionBtn(
                  Icons.delete_rounded,
                  color: Colors.redAccent,
                  onTap: widget.onDelete!,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _info(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade400),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: Colors.grey.shade300,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  // Menyesuaikan badge "Public" agar lebih seragam
  Widget _buildBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: widget.event.isPublic
            ? Colors.greenAccent.shade700
            : Colors.orange.shade700,
        borderRadius: BorderRadius.circular(8), // border radius dikurangi
      ),
      child: Text(
        widget.event.isPublic ? "Public" : "Private",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Menyesuaikan badge "Tanggal" agar lebih seragam
  Widget _buildDateBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade700,
        borderRadius: BorderRadius.circular(8), // border radius dikurangi
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_today,
            size: 14,
            color: Colors.white.withOpacity(0.9),
          ),
          const SizedBox(width: 6),
          Text(
            formattedDate,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _appleActionBtn(
      IconData icon, {
        Color color = Colors.white,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.10),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: Colors.white.withOpacity(0.18),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.28),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 16,
              color: color.withOpacity(0.95),
            ),
          ),
        ),
      ),
    );
  }
}