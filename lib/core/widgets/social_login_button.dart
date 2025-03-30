import 'package:flutter/material.dart';

import '../app_text_styles.dart';

class SocialLoginButton extends StatelessWidget {
  final Widget icon;
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;
  final double elevation;
  final bool hasShadow;

  const SocialLoginButton({
    Key? key,
    required this.icon,
    required this.text,
    required this.onPressed,
    required this.color,
    required this.textColor,
    this.elevation = 0,
    this.hasShadow = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(12),
        elevation: elevation,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          splashColor: textColor.withOpacity(0.1),
          highlightColor: textColor.withOpacity(0.05),
          child: Container(
            constraints: const BoxConstraints(minHeight: 56),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedScale(
                  duration: const Duration(milliseconds: 200),
                  scale: 1,
                  child: SizedBox(width: 24, height: 24, child: icon),
                ),
                const SizedBox(width: 16),
                Text(
                  text,
                  style: AppTextStyles.buttonMedium.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
