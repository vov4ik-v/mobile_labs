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
      final battery = await FlashlightPlugin.getBatteryLevel();
      emit(
        isOn
            ? FlashlightOn(batteryLevel: battery)
            : FlashlightOff(batteryLevel: battery),
      );
    } on PlatformException catch (e) {
      emit(FlashlightError(e.message ?? 'Unknown error'));
    }
  }

  Future<void> loadBattery() async {
    if (!isSupported) return;
    try {
      final battery = await FlashlightPlugin.getBatteryLevel();
      emit(FlashlightOff(batteryLevel: battery));
    } on PlatformException catch (_) {}
  }

  Future<void> turnOff() async {
    if (!isSupported) return;
    try {
      await FlashlightPlugin.turnOff();
      emit(FlashlightOff(batteryLevel: state.batteryLevel));
    } on PlatformException catch (e) {
      emit(FlashlightError(e.message ?? 'Unknown error'));
    }
  }
}
