import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/users/user_model.dart';
import '../../../data/db_user_utils.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  final DBUserUtils dbUserUtils = DBUserUtils.instance;

  @override
  UserModel? build() {
    getCurrentUser();
    return null;
  }

  // Sign up
  Future<bool> signUp({
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
  }) async {
    try {
      // Check if email already exists
      final emailExists = await dbUserUtils.emailExists(email);
      if (emailExists) {
        throw Exception("Email already registered");
      }

      await dbUserUtils.insertUser(
        email: email,
        password: password,
        fullName: fullName,
        phoneNumber: phoneNumber,
      );

      final user = await dbUserUtils.getUserByEmail(email);
      if (user != null) {
        state = dbUserUtils.userToUserModel(user);
        await dbUserUtils.deactivateAllUsers();
        await dbUserUtils.updateActiveState(user: user, isActive: true);
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  // Sign in
  Future<bool> signIn({required String email, required String password}) async {
    try {
      final user = await dbUserUtils.signIn(email: email, password: password);
      if (user != null) {
        state = dbUserUtils.userToUserModel(user);
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }

  // Sign out
  // void deActivate() async {
  //   await dbUserUtils.updateUserStatus(state!.id!, false);
  //   state = null;
  // }

  // Update user
  Future<void> updateUser({
    required String id,
    String? fullName,
    String? phoneNumber,
    String? password,
  }) async {
    try {
      await dbUserUtils.updateUser(
        id: id,
        fullName: fullName,
        phoneNumber: phoneNumber,
        password: password,
      );

      if (state != null) {
        state = state!.copyWith(
          fullName: fullName ?? state!.fullName,
          phoneNumber: phoneNumber ?? state!.phoneNumber,
          password: password ?? state!.password,
          updatedAt: DateTime.now(),
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  // Get current user
  Future<UserModel?> getCurrentUser() async {
    final users = await dbUserUtils.getAllActiveUsers();
    if (users.isNotEmpty) {
      state = dbUserUtils.userToUserModel(users.first);
    }
    return state;
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return state != null;
  }
}

@riverpod
bool isUserLoggedIn(Ref ref) {
  final authState = ref.watch(authProvider);
  return authState != null;
}
