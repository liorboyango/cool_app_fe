import 'package:dio/dio.dart';
import '../app_config/constants.dart';
import '../models/user.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: Constants.webServiceBaseUrl,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 10),
  ));

  ApiService() {
    _dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }

  Future<List<User>> fetchUsers() async {
    try {
      final response = await _dio.get('/api/users');
      if (response.statusCode == 200) {
        final data = response.data as List<dynamic>;
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch users: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }

  Future<Map<String, dynamic>> fetchStatus() async {
    try {
      final response = await _dio.get('/api/status');
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to fetch status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching status: $e');
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      final response = await _dio.delete('/api/users/$id');
      if (response.statusCode != 200) {
        throw Exception('Failed to delete user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting user: $e');
    }
  }

  Future<void> deleteUsers(List<int> ids) async {
    try {
      final response = await _dio.delete('/api/users', data: {'ids': ids});
      if (response.statusCode != 200) {
        throw Exception('Failed to delete users: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting users: $e');
    }
  }

  Future<void> addUser(User user) async {
    try {
      final response = await _dio.post('/api/users', data: user.toJson());
      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception('Failed to add user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error adding user: $e');
    }
  }

  Future<void> updateUser(User user) async {
    try {
      final response = await _dio.put('/api/users/${user.id}', data: user.toJson());
      if (response.statusCode != 200) {
        throw Exception('Failed to update user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating user: $e');
    }
  }
}