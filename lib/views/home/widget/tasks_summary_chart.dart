import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_sandbox/extensions/space_exs.dart';
import 'package:flutter_sandbox/utils/app_colors.dart';
import '../../../models/tasks.dart';



class TaskSummaryChartFixed extends StatefulWidget {
  final List<Task> tasks;
  const TaskSummaryChartFixed({super.key, required this.tasks});

  @override
  State<TaskSummaryChartFixed> createState() => _TaskSummaryChartFixedState();
}

class _TaskSummaryChartFixedState extends State<TaskSummaryChartFixed>
    with SingleTickerProviderStateMixin {
  late AnimationController _appearController;
  late ConfettiController _confettiController;
  int _touchedIndex = -1;
  bool _celebrationShown = false;

  // color map per category
  final Map<String, List<Color>> _categoryGradients = {
    'Completed': [const Color(0xFFCE93D8), const Color(0xFF8E24AA)],
    'Pending': [const Color(0xFFFFCC80), const Color(0xFFF57C00)],
    'Today': [const Color(0xFF9FA8DA), const Color(0xFF3F51B5)],
    'This Week': [const Color(0xFF80CBC4), const Color(0xFF00796B)],
    'All': [const Color(0xFF81D4FA), const Color(0xFF0288D1)],
  };

  @override
  void initState() {
    super.initState();
    _appearController = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
      ..forward();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _appearController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  Color _glowColorFor(String label) {
    final g = _categoryGradients[label] ?? [Colors.deepPurple, Colors.deepPurple];
    // alpha 0.28 => int 0.28*255 ≈ 71
    return g.last.withValues(alpha: (0.28 * 255).round().toDouble());
  }

  @override
  Widget build(BuildContext context) {
    final metrics = _computeMetrics(widget.tasks);
    final labels = metrics.keys.toList();
    final values = labels.map((k) => metrics[k]!).toList();
    final allTasks = metrics['All'] ?? 0;
    final totalForPercent = allTasks == 0 ? 1 : allTasks;

    final maxValue = values.isEmpty ? 1 : values.reduce(max);
    final maxY = max(1.0, maxValue * 1.2);

    /*// celebrate when all done
    final completed = metrics['Completed'] ?? 0;
    if (allTasks > 0 && completed == allTasks && !_celebrationShown) {
      Future.delayed(const Duration(milliseconds: 900), () {
        if (mounted) {
          setState(() {
            _celebrationShown = true;
          });
          _confettiController.play();
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) setState(() => _celebrationShown = false);
            _confettiController.stop();
          });
        }
      });
    }*/

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF5E9FA), Color(0xFFFFFFFF)],
          ),
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            // header
            Row(
              children: [
                const Icon(Icons.bar_chart, color: Color(0xFF6A1B9A)),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Task Summary',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF6A1B9A)),
                  ),
                ),
                _smallCounter("All", metrics['All'] ?? 0, Colors.deepPurple),
                const SizedBox(width: 12),
                _smallCounter("Done", metrics['Completed'] ?? 0, Colors.green),
              ],
            ),
            const SizedBox(height: 12),

            // chart area
            SizedBox(
              height: 200,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: maxY,
                        gridData: FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 60,
                              getTitlesWidget: (value, meta) {
                                final v = value.toInt();
                                if (v < 0 || v >= labels.length) return const SizedBox();
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    labels[v],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Color(0xFF6A1B9A), fontWeight: FontWeight.w600, fontSize: 12),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        barGroups: List.generate(labels.length, (i) {
                          final label = labels[i];
                          final value = values[i];
                          final grad = _categoryGradients[label] ?? [Colors.purple, Colors.deepPurple];
                          final isTouched = i == _touchedIndex;
                          final animationFactor = _appearController.value;
                          final animatedY = value.toDouble() * animationFactor;

                          return BarChartGroupData(
                            x: i,
                            barRods: [
                              BarChartRodData(
                                toY: isTouched ? (animatedY + (maxY * 0.06)) : animatedY,
                                width: isTouched ? 36 : 28,
                                borderRadius: BorderRadius.circular(14),
                                gradient: LinearGradient(colors: grad, begin: Alignment.bottomCenter, end: Alignment.topCenter),
                                rodStackItems: isTouched
                                    ? [BarChartRodStackItem(0, min(maxY, animatedY + (maxY * 0.12)), _glowColorFor(label))]
                                    : [],
                                backDrawRodData: BackgroundBarChartRodData(
                                  show: true,
                                  toY: maxY,
                                  gradient: LinearGradient(
                                    colors: [grad[0].withValues(alpha: (0.14 * 255).round().toDouble()), grad[0].withValues(alpha: (0.07 * 255).round().toDouble())],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                        barTouchData: BarTouchData(
                          enabled: true,
                          touchTooltipData: BarTouchTooltipData(
                            tooltipBorderRadius: BorderRadius.circular(12),
                            // CORRECT signature: Color Function(BarChartGroupData group)
                            getTooltipColor: (BarChartGroupData group) {
                              final idx = group.x;
                              if (idx >= 0 && idx < labels.length) {
                                final label = labels[idx];
                                final grad = _categoryGradients[label] ?? [Colors.deepPurple, Colors.deepPurple];
                                // alpha 0.9 => (0.9*255).round().toDouble()
                                return grad.last.withValues(alpha: (0.9 * 255).round().toDouble());
                              }
                              return Colors.deepPurple.withValues(alpha: (0.9 * 255).round().toDouble());
                            },
                            // correct getTooltipItem signature: (group, groupIndex, rod, rodIndex)
                            getTooltipItem: (BarChartGroupData group, int groupIndex, BarChartRodData rod, int rodIndex) {
                              final label = labels[groupIndex];
                              final value = values[groupIndex];
                              final percent = totalForPercent == 0 ? 0 : ((value / totalForPercent) * 100).toStringAsFixed(1);
                              return BarTooltipItem(
                                "$label\n$value tasks\n$percent%",
                                const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              );
                            },
                            fitInsideHorizontally: true,
                            tooltipPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            tooltipMargin: 6,
                          ),
                          touchCallback: (event, response) {
                            if (!event.isInterestedForInteractions || response == null || response.spot == null) {
                              setState(() => _touchedIndex = -1);
                              return;
                            }
                            setState(() {
                              _touchedIndex = response.spot!.touchedBarGroupIndex;
                            });
                          },
                        ),
                      ),
                      duration: const Duration(milliseconds: 900),
                      curve: Curves.easeOutCubic,
                    ),
                  ),

                  // floating percentage when touched
                  if (_touchedIndex >= 0 && _touchedIndex < labels.length)
                    Positioned(
                      top: 8,
                      left: _calcFloatingLeftPosition(context, _touchedIndex, labels.length),
                      child: _FloatingPercentage(
                        label: labels[_touchedIndex],
                        value: values[_touchedIndex],
                        total: totalForPercent,
                        color: (_categoryGradients[labels[_touchedIndex]] ?? [Colors.purple, Colors.purple]).last,
                      ),
                    ),

                  // confetti on celebration
                  if (_celebrationShown)
                    Positioned.fill(child: _CelebrationOverlay()),

                  // confetti controller overlay (always present but only plays when triggered)
                  Align(
                    alignment: Alignment.topCenter,
                    child: ConfettiWidget(
                      confettiController: _confettiController,
                      blastDirectionality: BlastDirectionality.explosive,
                      shouldLoop: false,
                      emissionFrequency: 0.05,
                      numberOfParticles: 25,
                      gravity: 0.2,
                    ),
                  ),
                ],
              ),
            ),

            // legend with animated counters
            Column(
              children: List.generate(labels.length, (i) {
                List<IconData> icons = [
                  Icons.check_circle_rounded,
                  Icons.pending,
                  Icons.today,
                  Icons.view_week,
                  Icons.task,
                ];
                List<Color> colors = [
                  Color(0xFFCE93D8),
                  Color(0xFFFFCC80),
                  Color(0xFF9FA8DA),
                  Color(0xFF80CBC4),
                  Color(0xFF81D4FA),
                ];
                final label = labels[i];
                final value = values[i];
                final icon = icons[i];
                final color = colors[i];
                final percent = ((value / totalForPercent) * 100).toStringAsFixed(0);
                final grad = _categoryGradients[label] ?? [Colors.purple, Colors.purple];

                return legendTile(icon, color, value, grad, label, percent, i);
              }),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, int> _computeMetrics(List<Task> tasks) {
    final now = DateTime.now();
    final completed = tasks.where((t) => t.isCompleted).length;
    final pending = tasks.where((t) => !t.isCompleted).length;
    final today = tasks.where((t) =>
    t.createdAtDate.year == now.year && t.createdAtDate.month == now.month && t.createdAtDate.day == now.day).length;
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    final thisWeek = tasks.where((t) => !t.createdAtDate.isBefore(startOfWeek) && !t.createdAtDate.isAfter(endOfWeek)).length;
    final all = tasks.length;
    return {'Completed': completed, 'Pending': pending, 'Today': today, 'This Week': thisWeek, 'All': all};
  }

  double _calcFloatingLeftPosition(BuildContext context, int index, int count) {
    final w = MediaQuery.of(context).size.width - 64; // some padding margin
    final colWidth = w / max(1, count);
    double left = colWidth * index + colWidth / 2 - 48;
    left = left.clamp(8.0, w - 96);
    return left;
  }
}

// Floating bubble
class _FloatingPercentage extends StatelessWidget {
  final String label;
  final int value;
  final int total;
  final Color color;
  const _FloatingPercentage({Key? key, required this.label, required this.value, required this.total, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final percent = total == 0 ? 0 : ((value / total) * 100).toStringAsFixed(0);
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: (0.95 * 255).round().toDouble()),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: color.withValues(alpha: (0.25 * 255).round().toDouble()), blurRadius: 8, spreadRadius: 1)],
        ),
        child: Column(
          children: [Text("$percent%", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11))],
        ),
      ),
    );
  }
}

// Simple celebration overlay (same as earlier but compact)
class _CelebrationOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        color: Colors.deepPurple.withValues(alpha: (0.12 * 255).round().toDouble()),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.emoji_events, color: Colors.amber, size: 72),
              SizedBox(height: 8),
              Text("All tasks complete! 🎉", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _smallCounter(String label, int value, Color color) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: value.toDouble()),
        duration: const Duration(milliseconds: 900),
        builder: (context, val, _) => Text(val.toInt().toString(), style: TextStyle(fontWeight: FontWeight.bold, color: color)),
      ),
      Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
    ],
  );
}

Widget legendTile(IconData icon, Color color, final value, final grad, final label, final percent, int i){

  return Container(
    margin: EdgeInsets.only(bottom: 7),
    child: Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: 0.0,
            minHeight: 23,
            valueColor: AlwaysStoppedAnimation(
                color
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                10.w,
                Icon(
                  icon,
                  size: 15,
                  color: AppColors.primaryColor,
                ),
                10.w,

                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: value.toDouble()),
                  duration: const Duration(milliseconds: 900),
                  builder: (context, val, _) => Text(
                    val.toInt().toString(),
                    style: TextStyle(color: grad.last, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                5.w,
                Text(
                  "$label",
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500
                  ),
                ),
              ],
            ),

            Container(
              margin: EdgeInsets.only(right: 10),
              child: Text(
                "• $percent%",
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500
                ),
              ),
            ),

          ],
        )
      ],
    ),
  );
}