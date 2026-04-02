import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  MqttServerClient? _client;
  final StreamController<String> _temperatureController =
      StreamController<String>.broadcast();

  Stream<String> get temperatureStream => _temperatureController.stream;

  bool get isConnected =>
      _client?.connectionStatus?.state == MqttConnectionState.connected;

  Future<bool> connectAndListen() async {
    if (isConnected) return true;

    _client = MqttServerClient(
      'broker.hivemq.com',
      'flutter_client_id_${DateTime.now().millisecondsSinceEpoch}',
    );
    _client!.port = 1883;
    _client!.logging(on: false);
    _client!.keepAlivePeriod = 20;
    _client!.autoReconnect = true;
    _client!.onDisconnected = () => debugPrint('MQTT Disconnected');
    _client!.onConnected = () => debugPrint('MQTT Connected to broker');
    _client!.onAutoReconnected = () => debugPrint('MQTT Auto-reconnected');

    final connMessage = MqttConnectMessage()
        .withClientIdentifier(_client!.clientIdentifier)
        .startClean()
        .withWillQos(MqttQos.atMostOnce);
    _client!.connectionMessage = connMessage;

    try {
      await _client!.connect();
    } catch (e) {
      debugPrint('MQTT Connection failed: $e');
      _client!.disconnect();
      return false;
    }

    if (_client!.connectionStatus!.state == MqttConnectionState.connected) {
      debugPrint('MQTT Connected!');
      const topic = 'sensor/temperature/labs';
      _client!.subscribe(topic, MqttQos.atMostOnce);

      _client!.updates!.listen((
        List<MqttReceivedMessage<MqttMessage>> messages,
      ) {
        final recMess = messages[0].payload as MqttPublishMessage;
        final payload = MqttPublishPayload.bytesToStringAsString(
          recMess.payload.message,
        );

        debugPrint('Received temperature from MQTT: $payload');
        _temperatureController.add(payload);
      });
      return true;
    }
    return false;
  }

  void publish(String topic, String message) {
    if (_client?.connectionStatus?.state != MqttConnectionState.connected) {
      debugPrint('MQTT not connected, cannot publish');
      return;
    }

    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client!.publishMessage(topic, MqttQos.atMostOnce, builder.payload!);
    debugPrint('MQTT Published "$message" to $topic');
  }

  void disconnect() {
    _client?.disconnect();
  }

  void dispose() {
    _temperatureController.close();
  }
}
