import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/cubits/mqtt_state.dart';
import 'package:mobile_labs/services/mqtt_service.dart';

class MqttCubit extends Cubit<MqttState> {
  final MqttService _mqttService;
  StreamSubscription<String>? _tempSub;

  MqttCubit(this._mqttService) : super(const MqttDisconnected());

  Future<void> connect() async {
    emit(const MqttConnecting());
    final ok = await _mqttService.connectAndListen();
    if (!ok) {
      emit(const MqttDisconnected());
      return;
    }
    emit(const MqttConnected('0.0'));
    _tempSub = _mqttService.temperatureStream.listen((v) {
      final t = double.tryParse(v);
      if (t != null) {
        emit(MqttConnected(t.toStringAsFixed(1)));
      }
    });
  }

  void publish(String topic, String message) {
    _mqttService.publish(topic, message);
  }

  void resetTemperature() {
    publish('sensor/command/labs', 'ADMIN_RESET');
    emit(const MqttConnected('0.0'));
  }

  @override
  Future<void> close() {
    _tempSub?.cancel();
    return super.close();
  }
}
