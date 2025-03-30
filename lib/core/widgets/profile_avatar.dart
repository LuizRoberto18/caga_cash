import 'package:flutter/material.dart';

import '../app_colors.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final VoidCallback onTap;
  final double size;

  const ProfileAvatar({
    Key? key,
    required this.imageUrl,
    required this.onTap,
    this.size = 100,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.primary.withOpacity(0.5),
            width: 3,
          ),
        ),
        child: Stack(
          children: [
            CircleAvatar(
              radius: size / 2,
              backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
                  ? NetworkImage(imageUrl!)
                  : const AssetImage('assets/default_avatar.png') as ImageProvider,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
