import 'package:flutter/material.dart';

class ConnectionIndicator extends StatelessWidget {
  final bool isConnecting;
  final bool isConnected;

  const ConnectionIndicator({
    required this.isConnecting,
    required this.isConnected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (isConnecting) {
      return const Padding(
        padding: EdgeInsets.only(right: 16),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Icon(
        isConnected ? Icons.wifi : Icons.wifi_off,
        color:
            isConnected ? Colors.green : Colors.red,
        size: 24,
      ),
    );
  }
}
