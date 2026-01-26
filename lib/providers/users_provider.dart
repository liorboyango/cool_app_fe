import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../services/api_service.dart';
import '../models/user.dart';

part 'users_provider.g.dart';

@riverpod
class UsersNotifier extends _$UsersNotifier {
  final ApiService _apiService = ApiService();

  @override
  Future<List<User>> build() async {
    return await _apiService.fetchUsers();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _apiService.fetchUsers());
  }

  Future<void> deleteUser(int id) async {
    await _apiService.deleteUser(id);
    await refresh();
  }

  Future<void> deleteUsers(List<int> ids) async {
    await _apiService.deleteUsers(ids);
    await refresh();
  }

  Future<void> addUser(User user) async {
    await _apiService.addUser(user);
    await refresh();
  }

  Future<void> updateUser(User user) async {
    await _apiService.updateUser(user);
    await refresh();
  }
}