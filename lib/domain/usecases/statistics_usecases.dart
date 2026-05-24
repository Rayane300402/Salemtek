import '../entities/medicine_statistic.dart';
import '../repo/statistics_repository.dart';

class StatisticsUseCases {
  final StatisticsRepository repository;

  StatisticsUseCases(this.repository);

  Future<List<MedicineStatistic>> getAll() {
    return repository.getAllStatistics();
  }

  Future<MedicineStatistic> add(MedicineStatistic statistic) {
    return repository.addStatistic(statistic);
  }

  Future<void> clearAll() {
    return repository.clearAllStatistics();
  }
}