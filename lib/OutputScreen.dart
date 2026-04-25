// ============================================================
// OutputScreen.dart — Form Summary Screen (Material Design 3)
// Author  : Adam Alafandi
// ============================================================

import 'package:flutter/material.dart';

class OutputScreen extends StatefulWidget {
  // ── All parameters match exactly what main.dart passes ────
  final String? username;
  final String? password;
  final String? email;
  final bool? rememberMe;
  final String? gender;
  final String? country;
  final double? age;
  final DateTime? selectedDate;

  const OutputScreen({
    super.key,
    this.username,
    this.password,
    this.email,
    this.rememberMe,
    this.gender,
    this.country,
    this.age,
    this.selectedDate,
  });

  @override
  State<OutputScreen> createState() => _OutputScreenState();
}

class _OutputScreenState extends State<OutputScreen>
    with SingleTickerProviderStateMixin {
  // Staggered slide-up animation for each info card
  late final AnimationController _controller;
  late final List<Animation<Offset>> _slideAnimations;
  late final List<Animation<double>> _fadeAnimations;

  // Number of info rows — must match _buildInfoRows() count
  static const int _rowCount = 8;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    // Each row staggers 80 ms after the previous one
    _slideAnimations = List.generate(_rowCount, (i) {
      final start = (i * 0.08).clamp(0.0, 0.7);
      final end = (start + 0.35).clamp(0.0, 1.0);
      return Tween<Offset>(
        begin: const Offset(0, 0.25),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeOutCubic),
        ),
      );
    });

    _fadeAnimations = List.generate(_rowCount, (i) {
      final start = (i * 0.08).clamp(0.0, 0.7);
      final end = (start + 0.35).clamp(0.0, 1.0);
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeOut),
        ),
      );
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ── Build ──────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;

    // Cap content width on tablets / wide screens
    final double horizontalPad = screenWidth > 600 ? screenWidth * 0.15 : 20;

    final rows = _buildInfoRows(cs, tt);

    return Scaffold(
      backgroundColor: cs.surface,
      // ── Custom app bar ───────────────────────────────────
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest.withOpacity(0.6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.arrow_back_ios_new_rounded,
                size: 16, color: cs.onSurface),
          ),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Go back',
        ),
        title: Text(
          'Submission Summary',
          style: tt.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: cs.onSurface,
          ),
        ),
        centerTitle: true,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPad,
            vertical: 8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Success banner ─────────────────────────
              _buildSuccessBanner(cs, tt),
              const SizedBox(height: 28),

              // ── Section label ──────────────────────────
              _sectionLabel('Account Info', cs, tt),
              const SizedBox(height: 12),

              // ── Account info card ──────────────────────
              _buildCard(
                cs,
                children: [
                  _animatedRow(rows[0], 0),
                  _divider(cs),
                  _animatedRow(rows[1], 1),
                  _divider(cs),
                  _animatedRow(rows[2], 2),
                ],
              ),
              const SizedBox(height: 24),

              // ── Section label ──────────────────────────
              _sectionLabel('Personal Details', cs, tt),
              const SizedBox(height: 12),

              // ── Personal info card ─────────────────────
              _buildCard(
                cs,
                children: [
                  _animatedRow(rows[3], 3),
                  _divider(cs),
                  _animatedRow(rows[4], 4),
                  _divider(cs),
                  _animatedRow(rows[5], 5),
                  _divider(cs),
                  _animatedRow(rows[6], 6),
                  _divider(cs),
                  _animatedRow(rows[7], 7),
                ],
              ),
              const SizedBox(height: 36),

              // ── Go back CTA ────────────────────────────
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Edit My Info'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(54),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ── Success banner at top ──────────────────────────────────
  Widget _buildSuccessBanner(ColorScheme cs, TextTheme tt) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            cs.primary.withOpacity(0.15),
            cs.tertiary.withOpacity(0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          // Animated check icon
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [cs.primary, cs.tertiary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: cs.primary.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.check_rounded,
                color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Form Submitted!',
                  style: tt.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Here\'s a summary of what you entered.',
                  style: tt.bodySmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Card container ─────────────────────────────────────────
  Widget _buildCard(ColorScheme cs, {required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  // ── Build all info rows ────────────────────────────────────
  // Order must match _rowCount (8 rows)
  List<_InfoRow> _buildInfoRows(ColorScheme cs, TextTheme tt) {
    final dateStr = widget.selectedDate != null
        ? '${widget.selectedDate!.day.toString().padLeft(2, '0')}/'
            '${widget.selectedDate!.month.toString().padLeft(2, '0')}/'
            '${widget.selectedDate!.year}'
        : 'Not selected';

    return [
      _InfoRow(
          icon: Icons.person_outline_rounded,
          label: 'Username',
          value: widget.username ?? '—',
          cs: cs,
          tt: tt),
      _InfoRow(
          icon: Icons.lock_outline_rounded,
          label: 'Password',
          // Mask password for security in the summary
          value: '●' * (widget.password?.length ?? 0),
          cs: cs,
          tt: tt),
      _InfoRow(
          icon: Icons.email_outlined,
          label: 'Email',
          value: widget.email ?? '—',
          cs: cs,
          tt: tt),
      _InfoRow(
          icon: Icons.wc_rounded,
          label: 'Gender',
          value: _capitalize(widget.gender ?? '—'),
          cs: cs,
          tt: tt),
      _InfoRow(
          icon: Icons.flag_outlined,
          label: 'Country',
          value: widget.country ?? '—',
          cs: cs,
          tt: tt),
      _InfoRow(
          icon: Icons.cake_outlined,
          label: 'Age',
          value: widget.age != null ? '${widget.age!.round()} years' : '—',
          cs: cs,
          tt: tt),
      _InfoRow(
          icon: Icons.calendar_month_outlined,
          label: 'Selected Date',
          value: dateStr,
          cs: cs,
          tt: tt),
      _InfoRow(
          icon: Icons.verified_user_outlined,
          label: 'Remember Me',
          value: (widget.rememberMe ?? false) ? 'Yes' : 'No',
          cs: cs,
          tt: tt,
          isLast: true),
    ];
  }

  // ── Animate a row with staggered slide+fade ────────────────
  Widget _animatedRow(_InfoRow row, int index) {
    return FadeTransition(
      opacity: _fadeAnimations[index],
      child: SlideTransition(
        position: _slideAnimations[index],
        child: row,
      ),
    );
  }

  // ── Divider inside card ────────────────────────────────────
  Widget _divider(ColorScheme cs) => Divider(
        height: 0,
        indent: 56,
        endIndent: 16,
        color: cs.outlineVariant.withOpacity(0.5),
      );

  // ── Section label helper ───────────────────────────────────
  Widget _sectionLabel(String label, ColorScheme cs, TextTheme tt) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label.toUpperCase(),
        style: tt.labelSmall?.copyWith(
          color: cs.primary,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.4,
        ),
      ),
    );
  }

  // ── Capitalise first letter ────────────────────────────────
  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

// ── Reusable info row inside a card ───────────────────────────
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ColorScheme cs;
  final TextTheme tt;
  final bool isLast;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.cs,
    required this.tt,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        isLast ? 14 : 14,
        16,
        isLast ? 14 : 14,
      ),
      child: Row(
        children: [
          // Icon badge
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: cs.primaryContainer.withOpacity(0.6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: cs.primary),
          ),
          const SizedBox(width: 16),

          // Label column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: tt.labelSmall?.copyWith(
                    color: cs.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: tt.bodyMedium?.copyWith(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}