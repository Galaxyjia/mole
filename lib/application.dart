import './game.dart';
import './display/Group.dart';
import 'dart:ui';
import 'package:flutter/gestures.dart';

class Application extends Game{
  Group stage;
  Size size;
  num width;
  num height;
  num color;
  
  num count;
  // Map options;

  Application([width=1024.0,height=2048.0,color=0xffffffff]){
    this.width = width;
    this.height = height;
    this.color = color;
    initialize();
  }

  void initialize() async{
    stage = Group();
  }

  drawBackground(Canvas canvas){
    Paint _paint = new Paint()
      ..color = Color(this.color)
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..strokeWidth = 5.0
      ..style = PaintingStyle.fill;
    var rect = Rect.fromLTWH(0.0, 0.0, this.width, this.height);
    canvas.drawRect(rect, _paint);
  }

  @override
  void render(Canvas canvas){
    drawBackground(canvas);
    stage.render(canvas);
  }

  onTapDown(TapDownDetails d){
   
  }
}