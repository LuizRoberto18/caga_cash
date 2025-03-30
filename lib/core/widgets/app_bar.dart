import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../app_text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final double elevation;
  final Color backgroundColor;
  final Widget? leading;

  const CustomAppBar({
    required this.title,
    this.showBackButton = false,
    this.actions,
    this.elevation = 0,
    this.backgroundColor = Colors.transparent,
    this.leading,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: elevation,
      title: Text(
        title,
        style: AppTextStyles.titleLarge.copyWith(
          color: AppColors.text,
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: true,
      leading: leading ??
          (showBackButton
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.text),
                  onPressed: () => Navigator.of(context).pop(),
                )
              : null),
      actions: actions,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
