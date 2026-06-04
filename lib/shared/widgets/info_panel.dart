import 'package:flutter/material.dart';

class InfoPanel extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final Widget? action;

  const InfoPanel({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.grey.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.cyan.shade700),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 6),
                  Text(body, style: TextStyle(color: Colors.grey.shade700)),
                  if (action != null) ...[const SizedBox(height: 10), action!],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
