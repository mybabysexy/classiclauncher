enum KeyState { keyDown, keyUp }

enum Input { select, back }

enum Direction { up, down, left, right }

class KeyPress {
  final int keyCode;
  final String _keyLabel;
  final KeyState state;

  KeyPress({required this.keyCode, required String keyLabel, required this.state}) : _keyLabel = _sanitize(keyLabel);

  factory KeyPress.fromMap(Map<dynamic, dynamic> map) {
    return KeyPress(keyCode: map['keyCode'], keyLabel: map['keyLabel'], state: map['state'] == 'keydown' ? KeyState.keyDown : KeyState.keyUp);
  }

  String get label => _keyLabel.trim().isEmpty ? _extraLabels() : _keyLabel;

  // Remove all invisible/control characters
  static String _sanitize(String input) {
    // Keep only visible ASCII and common printable Unicode
    final sanitized = input.runes
        .where((r) {
          // Allow space and visible characters, remove control/invisible ones
          return (r >= 32 && r <= 126) || (r > 126 && !isInvisibleUnicode(r));
        })
        .map((r) => String.fromCharCode(r))
        .join();
    return sanitized;
  }

  // Detect invisible Unicode characters outside ASCII
  static bool isInvisibleUnicode(int codePoint) {
    // Basic examples: zero-width space, non-breaking space, etc.
    const invisible = [
      0x200B, // ZERO WIDTH SPACE
      0x200C, // ZERO WIDTH NON-JOINER
      0x200D, // ZERO WIDTH JOINER
      0xFEFF, // ZERO WIDTH NO-BREAK SPACE
    ];
    return invisible.contains(codePoint);
  }

  String _extraLabels() {
    switch (keyCode) {
      case (19):
        return "TrackPad_UP";
      case (21):
        return "TrackPad_LEFT";
      case (20):
        return "TrackPad_DOWN";
      case (22):
        return "TrackPad_RIGHT";
      default:
        return "";
    }
  }

  bool get isTrackPadDirection => keyCode == 19 || keyCode == 20 || keyCode == 21 || keyCode == 22;

  Input? get input {
    switch (keyCode) {
      case 66:
        return Input.select;
      case 4:
        return Input.back;
    }
    return null;
  }

  Direction? get direction {
    switch (keyCode) {
      case 19:
        return Direction.up;

      case 20:
        return Direction.down;

      case 21:
        return Direction.left;

      case 22:
        return Direction.right;
    }
    return null;
  }

  @override
  String toString() => '$runtimeType(keyCode: $keyCode, state: $state, keyLabel: $label,)';
}
