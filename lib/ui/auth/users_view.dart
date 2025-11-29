import 'package:bill_printer/ui/auth/providers/auth_provider.dart';
import 'package:bill_printer/ui/auth/providers/users_provider.dart';
import 'package:bill_printer/ui/utils/app_colors.dart';
import 'package:bill_printer/ui/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class UsersView extends ConsumerStatefulWidget {
  const UsersView({super.key});

  @override
  ConsumerState<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends ConsumerState<UsersView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _showUserDetailsDialog(String userId) async {
    final users = await ref.read(usersListProvider.future);
    final user = users.firstWhere((u) => u.id == userId);

    final nameCtrl = TextEditingController(text: user.fullName);
    final phoneCtrl = TextEditingController(text: user.phoneNumber ?? '');

    if (!mounted) return;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('User Details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text('Email'),
                subtitle: Text(user.email ?? "no email"),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: phoneCtrl,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Created At'),
                subtitle: Text(
                  DateFormat.yMMMd().format(user.createdAt ?? DateTime.now()),
                ),
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.update),
                title: const Text('Updated At'),
                subtitle: Text(
                  DateFormat.yMMMd().format(user.updatedAt ?? DateTime.now()),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await ref
                    .read(usersListProvider.notifier)
                    .updateUserProfile(
                      userId: userId,
                      fullName: nameCtrl.text.trim(),
                      phoneNumber: phoneCtrl.text.trim(),
                    );
                if (mounted) {
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                  UIUtils.showSnackBar(
                    // ignore: use_build_context_synchronously
                    context: context,
                    text: "User updated successfully",
                  );
                }
              } catch (e) {
                if (mounted) {
                  UIUtils.showSnackBar(
                    // ignore: use_build_context_synchronously
                    context: context,
                    text: "Error: ${e.toString()}",
                    bgColor: AppColors.red,
                  );
                }
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDeleteUser(String userId, String userName) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete $userName?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm ?? false) {
      try {
        await ref.read(usersListProvider.notifier).deleteUser(userId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User deleted successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
        }
      }
    }
  }

  Future<void> _toggleUserStatus(
    String userId,
    bool currentStatus,
    String userName,
  ) async {
    try {
      await ref
          .read(usersListProvider.notifier)
          .updateUserStatus(userId, !currentStatus);
      ref.read(authProvider.notifier).getCurrentUser();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              currentStatus
                  ? '$userName has been deactivated'
                  : '$userName has been activated',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsersAsync = ref.watch(filteredUsersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Users'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () =>
                ref.read(usersListProvider.notifier).refreshUsers(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              onChanged: (query) =>
                  ref.read(userSearchProvider.notifier).setSearchQuery(query),
              decoration: InputDecoration(
                hintText: 'Search by email, name, or phone...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          ref
                              .read(userSearchProvider.notifier)
                              .setSearchQuery('');
                        },
                        icon: const Icon(Icons.clear),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          // Users list
          Expanded(
            child: filteredUsersAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: $error'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          ref.read(usersListProvider.notifier).refreshUsers(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              data: (users) {
                if (users.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        const Text('No users found'),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: users.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final user = users[index];
                    // final isCurrentUser = currentUser?.id == user.id;

                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: user.isActive!
                              ? Colors.green
                              : Colors.grey,
                          child: Text(
                            user.fullName!.isNotEmpty
                                ? user.fullName![0].toUpperCase()
                                : '?',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Row(
                          children: [
                            Expanded(child: Text(user.fullName ?? "")),
                            // if (isCurrentUser)
                            //   Container(
                            //     padding: const EdgeInsets.symmetric(
                            //       horizontal: 8,
                            //       vertical: 4,
                            //     ),
                            //     decoration: BoxDecoration(
                            //       color: Colors.green,
                            //       borderRadius: BorderRadius.circular(12),
                            //     ),
                            //     child: const Text(
                            //       'You',
                            //       style: TextStyle(
                            //         color: Colors.white,
                            //         fontSize: 12,
                            //       ),
                            //     ),
                            //   ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(user.email ?? ""),
                            if (user.phoneNumber != null &&
                                user.phoneNumber!.isNotEmpty)
                              Text(user.phoneNumber!),
                            const SizedBox(height: 4),
                            Text(
                              user.isActive! ? 'Active' : 'Inactive',
                              style: TextStyle(
                                color: user.isActive!
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        trailing: PopupMenuButton(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              child: const Row(
                                children: [
                                  Icon(Icons.info_outline),
                                  SizedBox(width: 8),
                                  Text('Details'),
                                ],
                              ),
                              onTap: () => _showUserDetailsDialog(user.id!),
                            ),
                            if (!user.isActive!) ...[
                              PopupMenuItem(
                                child: Row(
                                  children: [
                                    Icon(
                                      user.isActive!
                                          ? Icons.block
                                          : Icons.check_circle,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      user.isActive!
                                          ? 'Deactivate'
                                          : 'Activate',
                                    ),
                                  ],
                                ),
                                onTap: () => _toggleUserStatus(
                                  user.id!,
                                  user.isActive!,
                                  user.fullName!,
                                ),
                              ),

                              PopupMenuItem(
                                child: const Row(
                                  children: [
                                    Icon(Icons.delete, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                                onTap: () => _confirmDeleteUser(
                                  user.id!,
                                  user.fullName!,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
