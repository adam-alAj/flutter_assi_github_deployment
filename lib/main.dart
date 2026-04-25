// ============================================================
// main.dart — Premium Registration Form (Material Design 3)
// Author  : Adam Alafandi
// ============================================================

import 'package:auth_project/OutputScreen.dart';
import 'package:flutter/material.dart';

// ── Entry point ──────────────────────────────────────────────
void main() {
  runApp(const MyApp());
}

// ── Root application widget ───────────────────────────────────
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ── Color seed — deep indigo gives a rich, modern palette ──
    const Color seedColor = Color(0xFF5C6BC0); // Indigo 400

    return MaterialApp(
      title: 'Flutter Form — Adam Alafandi',
      debugShowCheckedModeBanner: false,

      // ── Light theme ────────────────────────────────────────
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.light,
        ),
        // Smooth, rounded input fields to match MD3 guidelines
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: seedColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:
                const BorderSide(color: Color(0xFFEF5350), width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:
                const BorderSide(color: Color(0xFFEF5350), width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: seedColor,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(54),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
            elevation: 0,
          ),
        ),
      ),

      // ── Dark theme ─────────────────────────────────────────
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.dark,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:
                const BorderSide(color: Color(0xFF9FA8DA), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:
                const BorderSide(color: Color(0xFFEF9A9A), width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide:
                const BorderSide(color: Color(0xFFEF9A9A), width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7986CB),
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(54),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
            elevation: 0,
          ),
        ),
      ),

      themeMode: ThemeMode.system, // follows device setting
      home: const MyFormScreen(),
    );
  }
}

// ── Form screen (stateful) ────────────────────────────────────
class MyFormScreen extends StatefulWidget {
  const MyFormScreen({super.key});

  @override
  State<MyFormScreen> createState() => _MyFormScreenState();
}

class _MyFormScreenState extends State<MyFormScreen>
    with SingleTickerProviderStateMixin {
  // ── Form state ─────────────────────────────────────────────
  final _formKey = GlobalKey<FormState>();
  String? _username;
  String? _password;
  String? _email;
  bool _rememberMe = false;
  String? _gender;
  String? _country;
  double _age = 18;
  DateTime? _selectedDate;

  // ── UI state ───────────────────────────────────────────────
  bool _isLoading = false;       // submit button loading state
  bool _passwordVisible = false; // toggle password visibility

  // ── Animation controller for header fade-in ────────────────
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  final List<String> _countries = [
    'Palestine',
    'Jordan',
    'Egypt',
    'Syria',
    'Iraq',
  ];
  final List<String> _genders = ['Male', 'Female'];

  @override
  void initState() {
    super.initState();
    // Subtle entrance animation for the header area
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  // ── Submit — logic unchanged, added loading state ──────────
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() => _isLoading = true);

      // Simulate a brief async operation (e.g., API call)
      await Future.delayed(const Duration(milliseconds: 600));

      if (!mounted) return;
      setState(() => _isLoading = false);

      // ── Smooth fade+slide transition to output screen ──────
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 450),
          pageBuilder: (_, animation, __) => OutputScreen(
            username: _username,
            password: _password,
            email: _email,
            rememberMe: _rememberMe,
            gender: _gender,
            country: _country,
            age: _age,
            selectedDate: _selectedDate,
          ),
          transitionsBuilder: (_, animation, __, child) {
            // Fade + slide-up transition
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.05),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                )),
                child: child,
              ),
            );
          },
        ),
      );
    }
  }

  // ── Date picker — logic unchanged ─────────────────────────
  Future<void> _selectDate(BuildContext context) async {
    final colorScheme = Theme.of(context).colorScheme;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2050),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: colorScheme,
        ),
        child: child!,
      ),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  // ── Build ──────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;

    // Cap form width at 600 px for tablet / large screens
    final double horizontalPad = screenWidth > 600 ? screenWidth * 0.15 : 20;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPad,
            vertical: 24,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Branded header ─────────────────────────
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: _buildHeader(cs, textTheme),
                ),

                const SizedBox(height: 32),

                // ── Section label ──────────────────────────
                _sectionLabel('Account Info', textTheme),
                const SizedBox(height: 12),

                // ── Username field ─────────────────────────
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Username',
                    hintText: 'Enter your username',
                    fillColor: cs.surfaceContainerHighest.withOpacity(0.45),
                    prefixIcon: Icon(Icons.person_outline_rounded,
                        color: cs.primary),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                  onSaved: (value) => _username = value,
                ),
                const SizedBox(height: 16),

                // ── Password field with visibility toggle ──
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'At least 6 characters',
                    fillColor: cs.surfaceContainerHighest.withOpacity(0.45),
                    prefixIcon:
                        Icon(Icons.lock_outline_rounded, color: cs.primary),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: cs.onSurfaceVariant,
                      ),
                      onPressed: () =>
                          setState(() => _passwordVisible = !_passwordVisible),
                    ),
                  ),
                  obscureText: !_passwordVisible,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                  onSaved: (value) => _password = value,
                ),
                const SizedBox(height: 16),

                // ── Email field ────────────────────────────
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'you@example.com',
                    fillColor: cs.surfaceContainerHighest.withOpacity(0.45),
                    prefixIcon:
                        Icon(Icons.email_outlined, color: cs.primary),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  onSaved: (value) => _email = value,
                ),
                const SizedBox(height: 24),

                // ── Section label ──────────────────────────
                _sectionLabel('Personal Details', textTheme),
                const SizedBox(height: 12),

                // ── Gender radio group ─────────────────────
                _buildGenderPicker(cs, textTheme),
                const SizedBox(height: 16),

                // ── Country dropdown ───────────────────────
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Country',
                    fillColor: cs.surfaceContainerHighest.withOpacity(0.45),
                    prefixIcon:
                        Icon(Icons.flag_outlined, color: cs.primary),
                  ),
                  value: _country,
                  dropdownColor: cs.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(14),
                  items: _countries
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) => setState(() => _country = v),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a country';
                    }
                    return null;
                  },
                  onSaved: (value) => _country = value,
                ),
                const SizedBox(height: 16),

                // ── Age slider ─────────────────────────────
                _buildAgeSlider(cs, textTheme),
                const SizedBox(height: 16),

                // ── Date picker field ──────────────────────
                _buildDateField(cs),
                const SizedBox(height: 16),

                // ── Remember me toggle ─────────────────────
                _buildRememberMe(cs, textTheme),
                const SizedBox(height: 32),

                // ── Submit CTA ─────────────────────────────
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _isLoading
                      ? const SizedBox(
                          height: 54,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : ElevatedButton.icon(
                          key: const ValueKey('submit'),
                          onPressed: _submitForm,
                          icon: const Icon(Icons.arrow_forward_rounded),
                          label: const Text('Submit'),
                        ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Header widget ──────────────────────────────────────────
  Widget _buildHeader(ColorScheme cs, TextTheme tt) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo / icon badge
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [cs.primary, cs.tertiary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: cs.primary.withOpacity(0.35),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(Icons.person_add_alt_1_rounded,
              color: Colors.white, size: 30),
        ),
        const SizedBox(height: 20),
        Text(
          'Flutter App - Adam Alafandi',
          style: tt.labelLarge?.copyWith(
            color: cs.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Create Account',
          style: tt.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: cs.onSurface,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Fill in the details below to get started',
          style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
        ),
      ],
    );
  }

  // ── Section label helper ───────────────────────────────────
  Widget _sectionLabel(String label, TextTheme tt) {
    final cs = Theme.of(context).colorScheme;
    return Text(
      label.toUpperCase(),
      style: tt.labelSmall?.copyWith(
        color: cs.primary,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.4,
      ),
    );
  }

  // ── Gender radio picker ────────────────────────────────────
  Widget _buildGenderPicker(ColorScheme cs, TextTheme tt) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withOpacity(0.45),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(Icons.wc_rounded, color: cs.primary, size: 22),
          const SizedBox(width: 12),
          Text('Gender', style: tt.bodyMedium?.copyWith(color: cs.onSurface)),
          const Spacer(),
          ..._genders.map(
            (gender) => Row(
              children: [
                Radio<String>(
                  value: gender.toLowerCase(),
                  groupValue: _gender,
                  onChanged: (v) => setState(() => _gender = v),
                  activeColor: cs.primary,
                  visualDensity: VisualDensity.compact,
                ),
                Text(gender,
                    style:
                        tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant)),
                const SizedBox(width: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Age slider ─────────────────────────────────────────────
  Widget _buildAgeSlider(ColorScheme cs, TextTheme tt) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withOpacity(0.45),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.cake_outlined, color: cs.primary, size: 22),
              const SizedBox(width: 12),
              Text('Age', style: tt.bodyMedium?.copyWith(color: cs.onSurface)),
              const Spacer(),
              // Age badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _age.round().toString(),
                  style: tt.labelMedium?.copyWith(
                    color: cs.onPrimaryContainer,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          Slider(
            value: _age,
            min: 18,
            max: 99,
            divisions: 81,
            label: _age.round().toString(),
            activeColor: cs.primary,
            inactiveColor: cs.primary.withOpacity(0.2),
            onChanged: (v) => setState(() => _age = v),
          ),
          // Min/max labels
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('18',
                    style: tt.labelSmall
                        ?.copyWith(color: cs.onSurfaceVariant)),
                Text('99',
                    style: tt.labelSmall
                        ?.copyWith(color: cs.onSurfaceVariant)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Date picker field ──────────────────────────────────────
  Widget _buildDateField(ColorScheme cs) {
    final tt = Theme.of(context).textTheme;
    final hasDate = _selectedDate != null;
    final dateStr = hasDate
        ? '${_selectedDate!.day.toString().padLeft(2, '0')}/'
            '${_selectedDate!.month.toString().padLeft(2, '0')}/'
            '${_selectedDate!.year}'
        : 'Tap to select a date';

    return InkWell(
      onTap: () => _selectDate(context),
      borderRadius: BorderRadius.circular(14),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Selected Date',
          fillColor: cs.surfaceContainerHighest.withOpacity(0.45),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          prefixIcon:
              Icon(Icons.calendar_month_outlined, color: cs.primary),
          suffixIcon: hasDate
              ? IconButton(
                  icon: Icon(Icons.cancel_outlined,
                      color: cs.onSurfaceVariant, size: 20),
                  onPressed: () => setState(() => _selectedDate = null),
                )
              : null,
        ),
        child: Text(
          dateStr,
          style: tt.bodyMedium?.copyWith(
            color: hasDate ? cs.onSurface : cs.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  // ── Remember me row ────────────────────────────────────────
  Widget _buildRememberMe(ColorScheme cs, TextTheme tt) {
    return GestureDetector(
      onTap: () => setState(() => _rememberMe = !_rememberMe),
      child: Row(
        children: [
          // Custom animated checkbox look
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: _rememberMe ? cs.primary : Colors.transparent,
              border: Border.all(
                color: _rememberMe ? cs.primary : cs.outline,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: _rememberMe
                ? const Icon(Icons.check_rounded,
                    color: Colors.white, size: 16)
                : null,
          ),
          const SizedBox(width: 12),
          Text(
            'Keep me signed in',
            style: tt.bodyMedium?.copyWith(color: cs.onSurface),
          ),
        ],
      ),
    );
  }
}
