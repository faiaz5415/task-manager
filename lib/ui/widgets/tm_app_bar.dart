import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:task_manager/data/auth_controller.dart';
import 'package:task_manager/ui/screens/update_profile_screen.dart';
import '../screens/login_screen.dart';

class TMAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TMAppBar({
    super.key,
    this.fromUpdateProfile,
  });

  final bool? fromUpdateProfile;

  @override
  Widget build(BuildContext context) {
    final user = AuthController.user!;
    final imageBytes = user.photo != null ? base64Decode(user.photo!) : null;

    return AppBar(
      foregroundColor: Colors.white,
      backgroundColor: Colors.green,
      title: GestureDetector(
        onTap: () {
          if (fromUpdateProfile ?? false) {
            return;
          }
          Navigator.pushNamed(context, UpdateProfileScreen.name);
        },
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: imageBytes != null ? MemoryImage(imageBytes) : null,
              child: imageBytes == null ? const Icon(Icons.person) : null,
            ),
            const SizedBox(
              width: 12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${user.firstName} ${user.lastName}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.white,
                      ),
                ),
                Text(
                  user.email,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ],
            )
          ],
        ),
      ),
      actions: [
        IconButton(
            onPressed: () => _onTapLogOutButton(context),
            icon: const Icon(
              Icons.logout_outlined,
              color: Colors.white,
            ))
      ],
    );
  }

  void _onTapLogOutButton(BuildContext context) {
    AuthController.clearAuthData();
    Navigator.pushNamedAndRemoveUntil(
      context,
      LoginScreen.name,
      (predicate) => false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
