import 'package:flutter/material.dart';

import '../../res/app_colors.dart';

class ToolsIconButton extends StatelessWidget {
  final IconData icon;
  final String tag;
  final Function() onPressed;
  final Color? color;

  const ToolsIconButton({
    super.key,
    required this.icon,
    required this.tag,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      foregroundColor: Colors.white,
      onPressed: onPressed,
      heroTag: tag,
      tooltip: tag,
      backgroundColor: color ?? AppColors.primary,
      child: Icon(icon),
    );
  }
}
