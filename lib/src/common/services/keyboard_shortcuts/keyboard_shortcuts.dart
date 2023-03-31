import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KeyboardShortcut extends StatelessWidget {
  final Widget child;
  final FocusNode? focusNode;
  final Map<Set<LogicalKeyboardKey>, VoidCallback> shortCuts;
  const KeyboardShortcut({
    required this.shortCuts,
    this.focusNode,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      autofocus: true,
      onKey: (RawKeyEvent event) {
        for (var shortcut in shortCuts.entries) {
          if (event.isKeyPressed(shortcut.key.first) &&
              event.isKeyPressed(shortcut.key.last)) {
            log('${shortcut.key.first}');
            log('${shortcut.key.last}');
            shortcut.value();
          }
        }
      },
      focusNode: focusNode ?? FocusNode(),
      child: child,
    );
  }
}
