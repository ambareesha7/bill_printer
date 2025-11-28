import 'package:bill_printer/data/db_user_utils.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/users/user_model.dart';

part 'users_provider.g.dart';

@riverpod
class UsersList extends _$UsersList {
  final DBUserUtils dbUserUtils = DBUserUtils.instance;

  @override
  Future<List<UserModel>> build() async {
    return _loadUsers();
  }

  Future<List<UserModel>> _loadUsers() async {
    try {
      final users = await dbUserUtils.getAllUsers();
      return users
          .map(
            (u) => UserModel(
              id: u.id,
              email: u.email,
              password: u.password,
              fullName: u.fullName,
              phoneNumber: u.phoneNumber,
              createdAt: u.createdAt,
              updatedAt: u.updatedAt,
              isActive: u.isActive,
            ),
          )
          .toList();
    } catch (e) {
      debugPrint("Error loading users: $e");
      return [];
    }
  }

  Future<void> refreshUsers() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadUsers());
  }

  Future<void> deleteUser(String userId) async {
    try {
      await dbUserUtils.deleteUser(userId);
      await refreshUsers();
    } catch (e) {
      debugPrint("Error deleting user: $e");
      rethrow;
    }
  }

  Future<void> updateUserStatus(String userId, bool isActive) async {
    try {
      await dbUserUtils.updateUserStatus(userId, isActive);
      await refreshUsers();
    } catch (e) {
      debugPrint("Error updating user status: $e");
      rethrow;
    }
  }

  Future<void> updateUserProfile({
    required String userId,
    String? fullName,
    String? phoneNumber,
  }) async {
    try {
      await dbUserUtils.updateUser(
        id: userId,
        fullName: fullName,
        phoneNumber: phoneNumber,
      );
      await refreshUsers();
    } catch (e) {
      debugPrint("Error updating user profile: $e");
      rethrow;
    }
  }
}

@riverpod
class UserSearch extends _$UserSearch {
  @override
  String build() {
    return '';
  }

  void setSearchQuery(String query) {
    state = query;
  }
}

@riverpod
Future<List<UserModel>> filteredUsers(Ref ref) async {
  final users = await ref.watch(usersListProvider.future);
  final searchQuery = ref.watch(userSearchProvider);

  if (searchQuery.isEmpty) {
    return users;
  }

  return users
      .where(
        (user) =>
            user.email!.toLowerCase().contains(searchQuery.toLowerCase()) ||
            user.fullName!.toLowerCase().contains(searchQuery.toLowerCase()) ||
            (user.phoneNumber?.toLowerCase().contains(
                  searchQuery.toLowerCase(),
                ) ??
                false),
      )
      .toList();
}
