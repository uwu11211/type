import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputListener extends StatelessWidget {
  const InputListener({
    Key? key,
    this.enabled = true,
    this.onSpacePressed,
    this.onBackspacePressed,
    this.onCtrlBackspacePressed,
    this.onCharacterInput,
    required this.focusNode,
    required this.child,
  }) : super(key: key);

  final FocusNode focusNode;
  final VoidCallback? onSpacePressed;
  final VoidCallback? onBackspacePressed;
  final VoidCallback? onCtrlBackspacePressed;
  final void Function(String character)? onCharacterInput;
  final bool enabled;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: focusNode,
      autofocus: true,
      onKey: (event) {
        if (enabled) {
          bool isCtrlPressed =
              Theme.of(context).platform == TargetPlatform.macOS
                  ? event.isAltPressed
                  : event.isControlPressed;
          if (event is RawKeyUpEvent) {
            return;
          }

          if (isCtrlPressed &&
              event.logicalKey == LogicalKeyboardKey.backspace) {
            onCtrlBackspacePressed?.call();
          }

          // Ignore if this is a modifier key
          if (event.isAltPressed ||
              event.isControlPressed ||
              event.isMetaPressed) {
            return;
          }

          if (event.logicalKey == LogicalKeyboardKey.space) {
            onSpacePressed?.call();
          } else if (event.logicalKey == LogicalKeyboardKey.backspace) {
            onBackspacePressed?.call();
          } else if (event.character != null) {
            onCharacterInput?.call(event.character!);
          }

          focusNode.requestFocus();
        }
      },
      child: child,
    );
  }
}
