import 'package:flutter/material.dart';
import 'package:mobile_labs/widgets/primary_button.dart';

class ProfileActions extends StatelessWidget {
  final VoidCallback onLogout;
  final VoidCallback onDelete;

  const ProfileActions({
    required this.onLogout,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          PrimaryButton(text: 'Log Out', onPressed: onLogout),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton(
              onPressed: onDelete,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.redAccent,
                side: const BorderSide(color: Colors.redAccent),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text('Delete Account'),
            ),
          ),
        ],
      ),
    );
  }
}
