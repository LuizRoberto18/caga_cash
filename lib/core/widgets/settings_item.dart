import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../app_text_styles.dart';

class SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showDivider;
  final Color? iconColor;
  final Color? iconBackgroundColor;
  final TextStyle? titleStyle;
  final EdgeInsetsGeometry? padding;
  final double iconSize;
  final double borderRadius;

  const SettingsItem({
    Key? key,
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
    this.showDivider = true,
    this.iconColor = AppColors.primary,
    this.iconBackgroundColor,
    this.titleStyle,
    this.padding,
    this.iconSize = 24,
    this.borderRadius = 12,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(borderRadius),
            splashColor: AppColors.primary.withOpacity(0.1),
            highlightColor: AppColors.primary.withOpacity(0.05),
            child: Padding(
              padding: padding ??
                  const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8,
                  ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: iconBackgroundColor ?? AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: iconColor,
                      size: iconSize,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: titleStyle ??
                          AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.text,
                          ),
                    ),
                  ),
                  if (trailing != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: trailing!,
                    ),
                  if (onTap != null && trailing == null)
                    Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textLight.withOpacity(0.5),
                      size: 28,
                    ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          Padding(
            padding: const EdgeInsets.only(left: 60, right: 8),
            child: Divider(
              height: 1,
              thickness: 1,
              color: AppColors.lightGrey.withOpacity(0.5),
            ),
          ),
      ],
    );
  }
}
