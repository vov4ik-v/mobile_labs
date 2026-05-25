sealed class FlashlightState {
  final int batteryLevel;
  const FlashlightState({this.batteryLevel = -1});
}

class FlashlightOff extends FlashlightState {
  const FlashlightOff({super.batteryLevel});
}

class FlashlightOn extends FlashlightState {
  const FlashlightOn({super.batteryLevel});
}

class FlashlightError extends FlashlightState {
  final String message;
  const FlashlightError(this.message, {super.batteryLevel});
}
