import 'package:flutter/material.dart';
import 'package:mobile_labs/utils/validators.dart';

Future<String?> showEditNameDialog(
  BuildContext context,
  String currentName,
) async {
  final controller = TextEditingController(
    text: currentName,
  );
  String? errorText;

  return showDialog<String>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          return AlertDialog(
            title: const Text('Edit Name'),
            content: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Name',
                errorText: errorText,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(14),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.pop(dialogContext),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  final validation =
                      Validators.validateName(
                    controller.text,
                  );
                  if (validation != null) {
                    setDialogState(
                      () => errorText = validation,
                    );
                    return;
                  }
                  Navigator.pop(
                    dialogContext,
                    controller.text.trim(),
                  );
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      );
    },
  );
}

Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String content,
  required String confirmText,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.redAccent,
            ),
            child: Text(confirmText),
          ),
        ],
      );
    },
  );
  return result ?? false;
}
