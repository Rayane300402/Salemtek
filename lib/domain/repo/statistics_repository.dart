import '../entities/medicine_statistic.dart';

abstract class StatisticsRepository {
  Future<List<MedicineStatistic>> getAllStatistics();
  Future<MedicineStatistic> addStatistic(MedicineStatistic statistic);
  Future<void> clearAllStatistics();
}