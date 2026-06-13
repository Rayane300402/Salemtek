import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../../configs/theme/palette.dart';
import '../../../../../domain/entities/medicine.dart';
import '../../../../../domain/entities/medicine_type.dart';
import '../../../../bloc/statistics/statistics_chart_data.dart';
import '../../../../bloc/statistics/statistics_state.dart';

/// Line chart of completed doses over time — one line per medicine, bucketed by
/// the active time filter (month -> days, year -> months, lifetime -> years).
class ProgressChart extends StatelessWidget {
  final StatChartData data;
  final List<Medicine> medicines;
  final StatisticsTimeFilterType timeFilterType;

  const ProgressChart({
    super.key,
    required this.data,
    required this.medicines,
    required this.timeFilterType,
  });

  static const List<Color> _seriesColors = [
    Color(0xff7C6FD6),
    Color(0xffA93F39),
    Color(0xff2FB6C4),
    Color(0xffE8943A),
    Color(0xff3A5495),
    Color(0xff4FA86B),
  ];

  Color _colorAt(int index) => _seriesColors[index % _seriesColors.length];

  String _nameFor(StatChartSeries series, Map<String, Medicine> byId) {
    return byId[series.medicineId]?.title ?? series.medicineType.label;
  }

  // How many x-axis labels to skip so the axis doesn't get crowded.
  int _bottomStep() {
    switch (timeFilterType) {
      case StatisticsTimeFilterType.month:
        return 5;
      case StatisticsTimeFilterType.year:
      case StatisticsTimeFilterType.lifetime:
        return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Container(
        height: 200,
        alignment: Alignment.center,
        child: Text(
          'No completed doses for this period',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Palette.text.withValues(alpha: 0.6),
          ),
        ),
      );
    }

    final byId = {for (final m in medicines) m.id: m};
    final step = _bottomStep();
    final maxX = (data.xLabels.length - 1).toDouble();
    final yInterval = data.maxY / 5;

    final bars = <LineChartBarData>[];
    for (var i = 0; i < data.series.length; i++) {
      final series = data.series[i];
      final spots = <FlSpot>[
        for (var x = 0; x < series.values.length; x++)
          FlSpot(x.toDouble(), series.values[x]),
      ];

      bars.add(
        LineChartBarData(
          spots: spots,
          isCurved: true,
          preventCurveOverShooting: true,
          color: _colorAt(i),
          barWidth: 2.5,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: maxX,
              minY: 0,
              maxY: data.maxY,
              lineTouchData: const LineTouchData(enabled: false),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: yInterval,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: Palette.text.withValues(alpha: 0.08),
                  strokeWidth: 1,
                ),
              ),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    interval: yInterval,
                    getTitlesWidget: (value, meta) => Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Text(
                        value.toInt().toString(),
                        style: TextStyle(
                          fontSize: 11,
                          color: Palette.text.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 24,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      final index = value.round();
                      if (index < 0 ||
                          index >= data.xLabels.length ||
                          index % step != 0) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          data.xLabels[index],
                          style: TextStyle(
                            fontSize: 11,
                            color: Palette.text.withValues(alpha: 0.5),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              lineBarsData: bars,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            for (var i = 0; i < data.series.length; i++)
              _LegendDot(
                color: _colorAt(i),
                label: _nameFor(data.series[i], byId),
              ),
          ],
        ),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Palette.text,
          ),
        ),
      ],
    );
  }
}
