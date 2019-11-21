import './display/DisplayObject.dart';
import 'dart:ui';
class Circle extends DisplayObject{
    double speed;
    num direction;

    Circle():super(){
      this.x =100.0;
      this.y =100.0;
      this.speed = 5.0;
      this.direction = 1;
    }

    render(Canvas canvas){
      Paint _paint = new Paint()
        ..color = Color(0xff6aff4c)
        ..strokeCap = StrokeCap.round
        ..isAntiAlias = true
        ..strokeWidth = 5.0
        ..style = PaintingStyle.stroke;

      canvas.drawCircle(
        Offset(this.x,this.y),
        30.0,
        _paint
          ..style = PaintingStyle.stroke);
    }
}