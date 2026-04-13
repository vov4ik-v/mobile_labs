sealed class FlashlightState {
  const FlashlightState();
}

class FlashlightOff extends FlashlightState {
  const FlashlightOff();
}

class FlashlightOn extends FlashlightState {
  const FlashlightOn();
}

class FlashlightError extends FlashlightState {
  final String message;
  const FlashlightError(this.message);
}
