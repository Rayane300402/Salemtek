import '../../domain/entities/medicine_statistic.dart';
import '../../domain/repo/statistics_repository.dart';
import '../models/medicine_statistic_model.dart';
import '../sources/statistics_local_datasource.dart';

class StatisticsRepositoryImpl implements StatisticsRepository {
  final StatisticsLocalDataSource localDataSource;

  StatisticsRepositoryImpl(this.localDataSource);

  @override
  Future<List<MedicineStatistic>> getAllStatistics() async {
    final models = await localDataSource.getAllStatistics();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<MedicineStatistic> addStatistic(MedicineStatistic statistic) async {
    final model = MedicineStatisticModel.fromEntity(statistic);
    final saved = await localDataSource.addStatistic(model);
    return saved.toEntity();
  }

  @override
  Future<void> clearAllStatistics() {
    return localDataSource.clearAllStatistics();
  }
}