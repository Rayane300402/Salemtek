import '../models/medicine_statistic_model.dart';

abstract class StatisticsLocalDataSource {
  Future<List<MedicineStatisticModel>> getAllStatistics();
  Future<MedicineStatisticModel> addStatistic(
      MedicineStatisticModel statistic,
      );
  Future<void> clearAllStatistics();
}

class StatisticsLocalDataSourceImpl implements StatisticsLocalDataSource {
  final List<MedicineStatisticModel> _statistics = [];

  @override
  Future<List<MedicineStatisticModel>> getAllStatistics() async {
    return List<MedicineStatisticModel>.from(_statistics);
  }

  @override
  Future<MedicineStatisticModel> addStatistic(
      MedicineStatisticModel statistic,
      ) async {
    _statistics.add(statistic);
    return statistic;
  }

  @override
  Future<void> clearAllStatistics() async {
    _statistics.clear();
  }
}