import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../app_text_styles.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final IconData? icon;
  final double borderRadius;
  final bool isDisabled;

  const CustomButton({
    required this.text,
    required this.onPressed,
    this.color,
    this.icon,
    this.borderRadius = 12.0,
    this.isDisabled = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isDisabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isDisabled ? Colors.grey : (color ?? AppColors.accent),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        elevation: isDisabled ? 0 : 6,
        shadowColor: Colors.black26,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.white,size:  30),
            const SizedBox(width: 8),
          ],
          Text(
            text,
            style: AppTextStyles.button,
          ),
        ],
      ),
    );
  }
}
