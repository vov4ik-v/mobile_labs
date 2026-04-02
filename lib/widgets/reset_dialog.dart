import 'package:flutter/material.dart';

Future<bool> showResetDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Admin Reset'),
      content: const Text('Send a reset command to the broker?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
          child: const Text('Reset'),
        ),
      ],
    ),
  );
  return result ?? false;
}
