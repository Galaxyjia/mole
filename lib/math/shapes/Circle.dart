import './Rectangle.dart';
import '../const.dart';

class Circle{
  num x;
  num y;
  num radius;
  num type;

  Circle(this.x,this.y,this.radius){
       this.type = SHAPES["CIRCLE"];
  }

  clone(){
        return new Circle(this.x, this.y, this.radius);
  }

  contains(x, y){
    if (this.radius <= 0){
            return false;
    }

    var r2 = this.radius * this.radius;
    var dx = (this.x - x);
    var dy = (this.y - y);

    dx *= dx;
    dy *= dy;

    return (dx + dy <= r2);
  }

  getBounds(){
    return new Rectangle(this.x - this.radius, this.y - this.radius, this.radius * 2, this.radius * 2);
  }

}