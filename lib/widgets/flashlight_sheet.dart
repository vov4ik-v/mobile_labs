import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/cubits/flashlight_cubit.dart';
import 'package:mobile_labs/cubits/flashlight_state.dart';

class FlashlightSheet extends StatelessWidget {
  const FlashlightSheet({super.key});

  static Future<void> show(BuildContext context) {
    final cubit = context.read<FlashlightCubit>();

    if (!cubit.isSupported) {
      return showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Not Supported'),
          content: const Text(
            'Flashlight is only supported on Android devices.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }

    return showModalBottomSheet<void>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: const FlashlightSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FlashlightCubit, FlashlightState>(
      builder: (context, state) {
        final isOn = state is FlashlightOn;
        return Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Secret Flashlight',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              IconButton(
                iconSize: 80,
                color: isOn ? Colors.amber : Colors.grey,
                onPressed: () =>
                    context.read<FlashlightCubit>().toggle(),
                icon: Icon(
                  isOn
                      ? Icons.flashlight_on
                      : Icons.flashlight_off,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isOn ? 'ON' : 'OFF',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isOn ? Colors.amber : Colors.grey,
                ),
              ),
              if (state is FlashlightError)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
