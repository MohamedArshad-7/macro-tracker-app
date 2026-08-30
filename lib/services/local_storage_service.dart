import '../models/goals.dart';

abstract class LocalStorageService {
  Future<void> saveGoals(DailyGoals goals);
  Future<DailyGoals?> getGoals();
  Future<void> clearAll();
}

class MockLocalStorageService implements LocalStorageService {
  DailyGoals? _goals;

  MockLocalStorageService() {
    _goals = DailyGoals();
  }

  @override
  Future<void> saveGoals(DailyGoals goals) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _goals = goals;
  }

  @override
  Future<DailyGoals?> getGoals() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _goals;
  }

  @override
  Future<void> clearAll() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _goals = null;
  }
}
