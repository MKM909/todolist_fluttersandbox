import 'package:flutter/material.dart';
import 'package:flutter_sandbox/views/home/components/wave_fancy_bottom_bar.dart';

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});
  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  final _controller = PageController();
  int _current = 0;

  final _tabs = const [
    WaveNavItem(icon: Icons.home_rounded,  label: "Home"),
    WaveNavItem(icon: Icons.settings_rounded, label: "Settings"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: const Text("Todo List")),

      // Pretty FAB
      floatingActionButton: Container(
        width: 65,
        height: 65,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Color(0xFF6C63FF), Color(0xFF9A6BFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 14, offset: Offset(0, 6)),
          ],
        ),
        child: RawMaterialButton(
          shape: const CircleBorder(),
          onPressed: () {
            // Add task action
          },
          child: const Icon(Icons.add, color: Colors.white, size: 30),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // Fancy bottom nav
      bottomNavigationBar: WaveFancyBottomNav(
        items: _tabs,
        controller: _controller,
        showLabels: false,
        activeColor: const Color(0xFFEEE5FF),  // light lavender for text/icon
        inactiveColor: const Color(0xFFE0D7FF).withValues(alpha: 0.8),
        barColor: const Color(0xFF4C3B9A),     // deep purple bar
        duration: const Duration(milliseconds: 260),
        fabGapWidth: 80,
        useWaveNotch: false,
      ),

      // Pages
      body: PageView(
        controller: _controller,
        onPageChanged: (i) => setState(() => _current = i),
        children: const [
          Center(child: Text("Home Page", style: TextStyle(fontSize: 22))),
          Center(child: Text("Settings Page", style: TextStyle(fontSize: 22))),
        ],
      ),
    );
  }
}