import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'app_config/constants.dart';

enum SortOption { nameAsc, nameDesc }

class UserNotifier extends ChangeNotifier {
  List<dynamic> _allUsers = [];
  List<dynamic> _filteredUsers = [];
  String _searchQuery = '';
  SortOption _sortBy = SortOption.nameAsc;
  String _genderFilter = 'all';
  bool _isLoading = false;
  Timer? _debounceTimer;

  List<dynamic> get filteredUsers => _filteredUsers;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  SortOption get sortBy => _sortBy;
  String get genderFilter => _genderFilter;

  Future<void> fetchUsers() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.get(Uri.parse('${Constants.webServiceBaseUrl}/api/users'));
      if (response.statusCode == 200) {
        _allUsers = json.decode(response.body);
        _applyFilters();
      } else {
        _allUsers = [];
        _filteredUsers = [];
      }
    } catch (e) {
      _allUsers = [];
      _filteredUsers = [];
    }
    _isLoading = false;
    notifyListeners();
  }

  void setSearch(String query) {
    _searchQuery = query;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _applyFilters();
      notifyListeners();
    });
  }

  void setSort(SortOption sort) {
    _sortBy = sort;
    _applyFilters();
    notifyListeners();
  }

  void setGenderFilter(String filter) {
    _genderFilter = filter;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    var result = List<dynamic>.from(_allUsers);
    // Filter gender
    if (_genderFilter != 'all') {
      result = result.where((u) => u['gender'] == _genderFilter).toList();
    }
    // Filter search
    if (_searchQuery.isNotEmpty) {
      result = result.where((u) =>
        ((u['name'] as String?) ?? '').toLowerCase().contains(_searchQuery.toLowerCase()) ||
        ((u['email'] as String?) ?? '').toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
    // Sort
    switch (_sortBy) {
      case SortOption.nameAsc:
        result.sort((a, b) => ((a['name'] as String?) ?? '').compareTo((b['name'] as String?) ?? ''));
        break;
      case SortOption.nameDesc:
        result.sort((a, b) => ((b['name'] as String?) ?? '').compareTo((a['name'] as String?) ?? ''));
        break;
    }
    _filteredUsers = result;
  }

  Future<void> deleteUser(int id) async {
    try {
      final response = await http.delete(Uri.parse('${Constants.webServiceBaseUrl}/api/users/$id'));
      if (response.statusCode == 200) {
        _allUsers.removeWhere((u) => u['id'] == id);
        _applyFilters();
        notifyListeners();
      }
    } catch (e) {}
  }

  Future<void> deleteUsers(List<int> ids) async {
    try {
      final response = await http.delete(
        Uri.parse('${Constants.webServiceBaseUrl}/api/users'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'ids': ids}),
      );
      if (response.statusCode == 200) {
        _allUsers.removeWhere((u) => ids.contains(u['id']));
        _applyFilters();
        notifyListeners();
      }
    } catch (e) {}
  }

  Future<void> addUser(Map<String, dynamic> userData) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.webServiceBaseUrl}/api/users'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userData),
      );
      if (response.statusCode == 201) {
        final newUser = json.decode(response.body);
        _allUsers.add(newUser);
        _applyFilters();
        notifyListeners();
      }
    } catch (e) {}
  }

  Future<void> updateUser(int id, Map<String, dynamic> userData) async {
    try {
      final response = await http.put(
        Uri.parse('${Constants.webServiceBaseUrl}/api/users/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userData),
      );
      if (response.statusCode == 200) {
        final index = _allUsers.indexWhere((u) => u['id'] == id);
        if (index != -1) {
          _allUsers[index] = {..._allUsers[index], ...userData};
          _applyFilters();
          notifyListeners();
        }
      }
    } catch (e) {}
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}