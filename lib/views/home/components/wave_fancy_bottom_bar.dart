import 'package:flutter/material.dart';

/// Model for each tab
class WaveNavItem {
  final IconData icon;
  final String label;
  const WaveNavItem({required this.icon, required this.label});
}

/// Fancy bottom nav with wave notch, ripple, scale, and glow bubble
class WaveFancyBottomNav extends StatefulWidget {
  /// 2–4 items only (keeps space for centered FAB)
  final List<WaveNavItem> items;

  /// Controls the PageView this nav switches
  final PageController controller;

  /// Whether to show labels under icons
  final bool showLabels;

  /// Primary/active color (icons + glow)
  final Color activeColor;

  /// Inactive icon/label color
  final Color inactiveColor;

  /// Bar background color
  final Color barColor;

  /// Duration for all animations
  final Duration duration;

  /// Width of the reserved gap for the center FAB + notch
  final double fabGapWidth;

  /// Size of the icons when there are exactly 2 tabs
  final double iconSize2;

  /// Size of the icons when there are 3–4 tabs
  final double iconSize34;

  /// Use wave notch or fallback to the default circular notch
  final bool useWaveNotch;

  const WaveFancyBottomNav({
    super.key,
    required this.items,
    required this.controller,
    this.showLabels = true,
    this.activeColor = const Color(0xFF6C63FF),
    this.inactiveColor = const Color(0xFFBDBDBD),
    this.barColor = const Color(0xFF3E2D7A),
    this.duration = const Duration(milliseconds: 260),
    this.fabGapWidth = 68,   // tuned to pair well with a 60–65 FAB
    this.iconSize2 = 28,
    this.iconSize34 = 23,
    this.useWaveNotch = true,
  })  : assert(items.length >= 2 && items.length <= 4,
  "WaveFancyBottomNav supports between 2 and 4 items.");

  @override
  State<WaveFancyBottomNav> createState() => _WaveFancyBottomNavState();
}

class _WaveFancyBottomNavState extends State<WaveFancyBottomNav> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // keep state in sync with page swipes
    widget.controller.addListener(() {
      final idx = widget.controller.page?.round();
      if (idx != null && idx != _currentIndex && mounted) {
        setState(() => _currentIndex = idx);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = widget.items.length;
    final iconSize = itemCount <= 2 ? widget.iconSize2 : widget.iconSize34;

    // Build row children with a reserved center gap for the FAB
    final children = <Widget>[];
    for (var i = 0; i < itemCount; i++) {
      // Insert gap at the visual middle
      if (i == (itemCount / 2).floor()) {
        children.add(SizedBox(width: widget.fabGapWidth));
      }
      children.add(_NavItemButton(
        index: i,
        icon: widget.items[i].icon,
        label: widget.items[i].label,
        isSelected: _currentIndex == i,
        onTap: () => _onTap(i),
        activeColor: widget.activeColor,
        inactiveColor: widget.inactiveColor,
        showLabel: widget.showLabels,
        duration: widget.duration,
        iconSize: iconSize,
      ));
    }

    return Container(
      color: const Color(0xFFEEE5FF),
      child: BottomAppBar(
        color: widget.barColor,
        notchMargin: 10,
        // swap to CircularNotchedRectangle() if you prefer the default notch
        shape: widget.useWaveNotch ? const _WaveNotchedShape() : const CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: children,
          ),
        ),
      ),
    );
  }

  void _onTap(int index) {
    // animate the page for a nicer feel
    widget.controller.animateToPage(
      index,
      duration: widget.duration,
      curve: Curves.easeOutCubic,
    );
    setState(() => _currentIndex = index);
  }
}

/// Individual item with ripple, scale, and glow bubble
class _NavItemButton extends StatelessWidget {
  final int index;
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color activeColor;
  final Color inactiveColor;
  final bool showLabel;
  final Duration duration;
  final double iconSize;

  const _NavItemButton({
    super.key,
    required this.index,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.activeColor,
    required this.inactiveColor,
    required this.showLabel,
    required this.duration,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    // Use Material + InkWell to get proper ink ripple
    return Expanded(
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          splashFactory: InkRipple.splashFactory,
          splashColor: activeColor.withValues(alpha: 0.18),
          highlightColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Glow bubble behind the active icon
                AnimatedContainer(
                  duration: duration,
                  curve: Curves.easeIn,
                  width: isSelected ? iconSize + 50 : 0,
                  height: isSelected ? iconSize + 50 : 0,
                  decoration: BoxDecoration(
                    color: isSelected ? activeColor.withValues(alpha: 0.15) : Colors.transparent,
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: isSelected
                        ? [
                      BoxShadow(
                        color: activeColor.withValues(alpha: 0.25),
                        blurRadius: 16,
                        spreadRadius: 1,
                        offset: const Offset(0, 6),
                      ),
                    ]
                        : const [],
                  ),
                ),

                // Icon + optional label column
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // scale-up bounce on select
                    AnimatedScale(
                      scale: isSelected ? 1.22 : 1.0,
                      duration: duration,
                      curve: Curves.easeOutBack,
                      child: Icon(
                        icon,
                        size: iconSize,
                        color: isSelected ? activeColor : inactiveColor,
                      ),
                    ),
                    if (showLabel)
                      AnimatedDefaultTextStyle(
                        duration: duration,
                        curve: Curves.easeOut,
                        style: TextStyle(
                          fontSize: 11,
                          height: 1.4,
                          color: isSelected ? activeColor : inactiveColor.withOpacity(0.75),
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                        ),
                        child: Text(label),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Smooth “wave” notch around the FAB (optional)
class _WaveNotchedShape extends NotchedShape {
  const _WaveNotchedShape();

  @override
  Path getOuterPath(Rect host, Rect? guest) {
    if (guest == null || !guest.overlaps(host)) {
      return Path()..addRect(host);
    }

    final r = guest.width / 2; // FAB radius
    final left = guest.center.dx - r - 15;
    final right = guest.center.dx + r + 15;

    final path = Path()..moveTo(host.left, host.top);

    // Left flat until the curve
    path.lineTo(left, host.top);

    // Ease into the notch
    path.quadraticBezierTo(
      guest.center.dx - r, host.top,
      guest.center.dx - r, host.top + 10,
    );

    // Arc around the FAB
    path.arcToPoint(
      Offset(guest.center.dx + r, host.top + 10),
      radius: Radius.circular(r + 10),
      clockwise: false,
    );

    // Ease out of the notch
    path.quadraticBezierTo(
      guest.center.dx + r, host.top,
      right, host.top,
    );

    // Finish the rect
    path.lineTo(host.right, host.top);
    path.lineTo(host.right, host.bottom);
    path.lineTo(host.left, host.bottom);
    path.close();
    return path;
  }
}