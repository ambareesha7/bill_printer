import 'package:bill_printer/data/database.dart';
import 'package:bill_printer/data/db_utils.dart';
import 'package:bill_printer/data/models/users/user_model.dart';
import 'package:bill_printer/ui/utils/common_utils.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class DBUserUtils {
  DBUserUtils._internal();

  static DBUserUtils get instance => _instance;
  static final DBUserUtils _instance = DBUserUtils._internal();
  final db = DBUtils.db;
  // Sign up - Create user
  Future<void> insertUser({
    required String email,
    required String password,
    required String fullName,
    String? phoneNumber,
  }) async {
    try {
      final userCompanion = UsersCompanion.insert(
        id: Uuid().v7(),
        email: email,
        password: password,
        fullName: fullName,
        phoneNumber: phoneNumber != null
            ? Value(phoneNumber)
            : const Value.absent(),
        isActive: Value(true),
        createdAt: Value(DateTime.now()),
        updatedAt: Value(DateTime.now()),
      );
      final userId = await db.into(db.users).insert(userCompanion);
      debugLog("User created with id: $userId");
      // return userId;
    } catch (e) {
      debugLog("Error creating user: $e");
      rethrow;
    }
  }

  // Sign in - Get user by email and password
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final user = await (db.select(
        db.users,
      )..where((tbl) => tbl.email.equals(email))).getSingleOrNull();

      if (user != null && user.password == password && user.isActive) {
        debugLog("User signed in: ${user.email}");
        return user;
      } else if (user != null && user.password == password && !user.isActive) {
        /// any given time there should be a single isActive user in DB
        await deactivateAllUsers();
        // then updating current user to active state
        await updateActiveState(user: user, isActive: true);
        return user;
      }
      debugLog("Invalid credentials");
      return null;
    } catch (e) {
      debugLog("Error signing in: $e");
      return null;
    }
  }

  // signOut(String id) async {
  //   User? user = await getUserById(id);
  //   if (user == null) return;
  //   await updateActiveState(user: user, isActive: false);
  // }

  deactivateAllUsers() async {
    List<User> users = await getAllActiveUsers();
    for (var u in users) {
      await updateActiveState(user: u, isActive: false);
    }
  }

  Future<void> updateActiveState({
    required User user,
    required bool isActive,
  }) async {
    try {
      user = user.copyWith(isActive: isActive, updatedAt: DateTime.now());
      await db.update(db.users).replace(user);
      debugLog("updateActiveState: $user");
    } catch (e) {
      debugLog("Error updateActiveState: $e");
      rethrow;
    }
  }

  // Update user status (active/inactive)
  Future<void> updateUserStatus(String id, bool isActive) async {
    final user = await getUserById(id);
    await deactivateAllUsers();
    await updateActiveState(user: user!, isActive: isActive);
  }

  // Get active users count
  Future<int> getActiveUsersCount() async {
    try {
      final count =
          await (db.selectOnly(db.users)
                ..addColumns([db.users.id])
                ..where(db.users.isActive.equals(true)))
              .get();
      return count.length;
    } catch (e) {
      debugLog("Error fetching active users count: $e");
      return 0;
    }
  }

  Future<List<User>> getAllActiveUsers() async {
    try {
      final users = await (db.select(
        db.users,
      )..where((tbl) => tbl.isActive.equals(true))).get();
      return users;
    } catch (e) {
      debugLog("Error getAllActiveUsers: $e");
      return [];
    }
  }
  // Add these methods to the existing DBUserUtils class

  // Get all users
  Future<List<User>> getAllUsers() async {
    try {
      final users = await db.select(db.users).get();
      return users;
    } catch (e) {
      debugLog("Error fetching all users: $e");
      return [];
    }
  }

  Future<User?> getUserByEmail(String email) async {
    try {
      final user = await (db.select(
        db.users,
      )..where((tbl) => tbl.email.equals(email))).getSingleOrNull();
      return user;
    } catch (e) {
      debugLog("Error fetching user: $e");
      return null;
    }
  }

  Future<User?> getUserById(String id) async {
    try {
      final user = await (db.select(
        db.users,
      )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
      return user;
    } catch (e) {
      debugLog("Error fetching user: $e");
      return null;
    }
  }

  Future<void> updateUser({
    required String id,
    String? fullName,
    String? phoneNumber,
    String? password,
  }) async {
    try {
      final userCompanion = UsersCompanion(
        id: Value(id),
        fullName: fullName != null ? Value(fullName) : const Value.absent(),
        phoneNumber: phoneNumber != null
            ? Value(phoneNumber)
            : const Value.absent(),
        password: password != null ? Value(password) : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      );
      await db.update(db.users).replace(userCompanion);
      debugLog("User updated");
    } catch (e) {
      debugLog("Error updating user: $e");
      rethrow;
    }
  }

  // Delete user
  Future<void> deleteUser(String id) async {
    try {
      await (db.delete(db.users)..where((tbl) => tbl.id.equals(id))).go();
      debugLog("User deleted");
    } catch (e) {
      debugLog("Error deleting user: $e");
      rethrow;
    }
  }

  // Check if email exists
  Future<bool> emailExists(String email) async {
    try {
      final user = await getUserByEmail(email);
      return user != null;
    } catch (e) {
      debugLog("Error checking email: $e");
      return false;
    }
  }

  UserModel userToUserModel(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      password: user.password,
      fullName: user.fullName,
      phoneNumber: user.phoneNumber,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      isActive: user.isActive,
    );
  }
}
