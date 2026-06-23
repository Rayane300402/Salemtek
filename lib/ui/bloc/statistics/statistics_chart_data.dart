import '../../../domain/entities/medicine_type.dart';

class StatChartSeries {
  final String medicineId;
  final MedicineType medicineType;
  final List<double> values;

  const StatChartSeries({
    required this.medicineId,
    required this.medicineType,
    required this.values,
  });
}

class StatChartData {
  final List<String> xLabels;
  final List<StatChartSeries> series;
  final double maxY;

  const StatChartData({
    required this.xLabels,
    required this.series,
    required this.maxY,
  });

  factory StatChartData.empty() {
    return const StatChartData(xLabels: [], series: [], maxY: 0);
  }

  bool get isEmpty => series.isEmpty || xLabels.isEmpty;
}
