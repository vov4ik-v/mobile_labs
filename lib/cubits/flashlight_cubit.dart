import 'package:flashlight_plugin/flashlight_plugin.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/cubits/flashlight_state.dart';

class FlashlightCubit extends Cubit<FlashlightState> {
  FlashlightCubit() : super(const FlashlightOff());

  bool get isSupported => FlashlightPlugin.isSupported;

  Future<void> toggle() async {
    if (!isSupported) {
      emit(const FlashlightError(
        'Flashlight is only supported on Android.',
      ));
      return;
    }

    try {
      final isOn = await FlashlightPlugin.toggle();
      emit(isOn ? const FlashlightOn() : const FlashlightOff());
    } on PlatformException catch (e) {
      emit(FlashlightError(e.message ?? 'Unknown error'));
    }
  }

  Future<void> turnOff() async {
    if (!isSupported) return;
    try {
      await FlashlightPlugin.turnOff();
      emit(const FlashlightOff());
    } on PlatformException catch (e) {
      emit(FlashlightError(e.message ?? 'Unknown error'));
    }
  }
}
