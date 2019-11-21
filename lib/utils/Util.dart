import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';

import 'dart:async';
import 'dart:ui';

import 'dart:ui' as ui show TextStyle;

class Util {
  Future<void> fullScreen() {
    return SystemChrome.setEnabledSystemUIOverlays([]);
  }

  Future<void> setOrientation(DeviceOrientation orientation) {
    return SystemChrome.setPreferredOrientations([orientation]);
  }

  Future<Size> initialDimensions() async {
    // https://github.com/flutter/flutter/issues/5259
    // "In release mode we start off at 0x0 but we don't in debug mode"
    return await new Future<Size>(() {
      if (window.physicalSize.isEmpty) {
        var completer = new Completer<Size>();
        window.onMetricsChanged = () {
          if (!window.physicalSize.isEmpty) {
            completer.complete(window.physicalSize);
          }
        };
        return completer.future;
      }
      return window.physicalSize;
    });
  }

  void addGestureRecognizer(GestureRecognizer recognizer) {
    if (GestureBinding.instance == null) {
      throw Exception(
          'GestureBinding is not initialized yet, this probably happened because addGestureRecognizer was called before the runApp method');
    }

    GestureBinding.instance.pointerRouter.addGlobalRoute((PointerEvent e) {
      if (e is PointerDownEvent) {
        recognizer.addPointer(e);
      }
    });
  }

  void enableEvents() {
    new _CustomBinder();
  }

  Paragraph text(String text, { double fontSize = 24.0, Color color = Colors.white, fontFamily: 'Arial', double maxWidth = 180.0 }) {
    ParagraphBuilder paragraph = new ParagraphBuilder(new ParagraphStyle());
    paragraph.pushStyle(new ui.TextStyle(color: color, fontSize: fontSize, fontFamily: fontFamily));
    paragraph.addText(text);
    return paragraph.build()..layout(new ParagraphConstraints(width: maxWidth));
  }
}

class _CustomBinder extends BindingBase with ServicesBinding {
}

