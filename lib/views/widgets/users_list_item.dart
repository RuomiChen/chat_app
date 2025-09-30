import 'package:chat_app/controllers/users_list_controller.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserListItem extends StatelessWidget {
  final UserModel user;
  final VoidCallback onTap;
  final UsersListController controller;

  const UserListItem({
    super.key,
    required this.user,
    required this.onTap,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final relationshipStatus = controller.getUserRelationshipStatus(user.id);

      if (relationshipStatus == UserRelationshipStatus.friends) {
        return SizedBox.shrink();
      }

      return Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppTheme.primaryColor,
                child: Text(
                  user.displayName.isNotEmpty
                      ? user.displayName[0].toUpperCase()
                      : '?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.displayName,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      user.email,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  _buildActionButton(relationshipStatus),
                  if (relationshipStatus ==
                      UserRelationshipStatus.friendRequestReceived) ...[
                    SizedBox(height: 4),
                    OutlinedButton.icon(
                      onPressed: () => controller.declineFriendRequest(user),
                      label: Text('Decline', style: TextStyle(fontSize: 10)),
                      icon: Icon(Icons.close, size: 14),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.errorColor,
                        side: BorderSide(color: AppTheme.errorColor),
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 4,
                        ),
                        minimumSize: Size(0, 24),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildActionButton(UserRelationshipStatus relationshipStatus) {
    switch (relationshipStatus) {
      case UserRelationshipStatus.none:
        return _primaryButton(relationshipStatus);

      case UserRelationshipStatus.friendRequestSent:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _statusChip(relationshipStatus),
            const SizedBox(height: 8),
            _cancelButton(),
          ],
        );

      case UserRelationshipStatus.friendRequestReceived:
        return _primaryButton(relationshipStatus);

      case UserRelationshipStatus.blocked:
        return Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: AppTheme.errorColor.withOpacity(0.1),
            border: Border.all(color: AppTheme.errorColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.block, color: AppTheme.errorColor, size: 16),
              const SizedBox(width: 4),
              Text(
                'Blocked',
                style: TextStyle(
                  color: AppTheme.errorColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );

      case UserRelationshipStatus.friends:
        return const SizedBox.shrink(); // 已在上层判断，这里可选
    }
  }

  Widget _statusChip(UserRelationshipStatus status) {
    final color = controller.getRelationshipButtonColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            controller.getRelationshipButtonIcon(status),
            color: color,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            controller.getRelationshipButtonText(status),
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  void _showCancelRequestDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Cancel Friend'),
        content: Text(
          'Are you sure you want to cancel the friend request to ${user.displayName}',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Keep Request')),
          TextButton(
            onPressed: () {
              Get.back();
              controller.cancelFriendRequest(user);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            child: Text('Cancel Request'),
          ),
        ],
      ),
    );
  }

  Widget _cancelButton() {
    return ElevatedButton.icon(
      onPressed: _showCancelRequestDialog,
      icon: const Icon(Icons.cancel, size: 14),
      label: const Text('Cancel', style: TextStyle(fontSize: 12)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        minimumSize: const Size(0, 28),
      ),
    );
  }

  Widget _primaryButton(UserRelationshipStatus status) {
    return ElevatedButton.icon(
      onPressed: () => controller.handleRelationshipAction(user),
      icon: Icon(controller.getRelationshipButtonIcon(status)),
      label: Text(controller.getRelationshipButtonText(status)),
      style: ElevatedButton.styleFrom(
        backgroundColor: controller.getRelationshipButtonColor(status),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        minimumSize: const Size(0, 32),
      ),
    );
  }
}
