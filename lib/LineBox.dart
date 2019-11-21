import './display/Group.dart';

// import './display/DisplayObject.dart';
import 'dart:ui';

class LineBox extends Group{

  LineBox():super(){
    this.x=0.0;
    this.y=0.0;
  }

  update(t){

  }

  render(Canvas canvas){
     Paint _paint = new Paint()
      ..color = Color(0xffffff00)
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke;

      Rect rect = Rect.fromCircle(center: Offset(this.x.toDouble(), this.y.toDouble()), radius: 50.0*this.scale.x);
      RRect rrect = RRect.fromRectAndRadius(rect, Radius.circular(20.0*this.scale.y));
      canvas.drawRRect(rrect, _paint);
  }

  // _calculateBounds(){
  // }

}