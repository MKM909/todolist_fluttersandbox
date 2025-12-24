import 'package:flutter/material.dart';
import 'package:flutter_sandbox/views/home/components/fab.dart';
import 'package:flutter_sandbox/views/home/components/wave_fancy_bottom_bar.dart';
import 'package:flutter_sandbox/views/home/home_view.dart';
import 'package:flutter_sandbox/views/settings/settins_view.dart';

class MainViewPage extends StatefulWidget {
  const MainViewPage({super.key});
  @override
  State<MainViewPage> createState() => _MainViewPageState();
}

class _MainViewPageState extends State<MainViewPage> {
  final _controller = PageController();
  int _current = 0;

  final _tabs = const [
    WaveNavItem(icon: Icons.checklist_rounded,  label: "Home"),
    WaveNavItem(icon: Icons.settings, label: "Settings"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.transparent,

      // Pretty FAB
      floatingActionButton: const Fab(),
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Colors.white,
                Color(0xFFEEE5FF),
                ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            tileMode: TileMode.decal,
          )
        ),
        child: PageView(
          controller: _controller,
          onPageChanged: (i) => setState(() => _current = i),
          children: const [
            HomeView(),
            SettingsPage(),
          ],
        ),
      ),
    );
  }
}