sealed class MqttState {
  const MqttState();
}

class MqttDisconnected extends MqttState {
  const MqttDisconnected();
}

class MqttConnecting extends MqttState {
  const MqttConnecting();
}

class MqttConnected extends MqttState {
  final String temperature;
  const MqttConnected(this.temperature);
}
