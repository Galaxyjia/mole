import '../const.dart';
import 'dart:math';

class Rectangle{
  num x;
  num y;
  num width;
  num height;
  num type;

  Rectangle([x=0,y=0,width=0,height=0]){
    this.x =x;
    this.y =y;
    this.width =width;
    this.height = height;
    this.type = SHAPES["RECT"];
  }

  get left{
    return this.x;
  }

  get right{
    return this.x+this.width;
  }

  get top{
    return this.y;
  }

  get bottom{
    return this.y+this.height;
  }

  static get empty{
    return new Rectangle(0,0,0,0);
  }

  clone(){
    return new Rectangle(this.x,this.y,this.width,this.height);
  }

  copyFrom(rectangle){
    this.x = rectangle.x;
    this.y = rectangle.y;
    this.width = rectangle.width;
    this.height = rectangle.height;

    return this;
  }

  copyTo(rectangle){
    rectangle.x = this.x;
    rectangle.y = this.y;
    rectangle.width = this.width;
    rectangle.height = this.height;

    return rectangle;
  }

  contains(x, y){
    if (this.width <= 0 || this.height <= 0){
            return false;
    }

    if (x >= this.x && x < this.x + this.width){
        if (y >= this.y && y < this.y + this.height){
                return true;
        }
    }

    return false;
  }

  pad(paddingX, paddingY){
    paddingX = paddingX ?? 0;
        paddingY = paddingY ?? ((paddingY != 0) ? paddingX : 0);
        this.x -= paddingX;
        this.y -= paddingY;

        this.width += paddingX * 2;
        this.height += paddingY * 2;
  }

  fit(rectangle){
      var x1 = max<num>(this.x, rectangle.x);
      var x2 = min<num>(this.x + this.width, rectangle.x + rectangle.width);
      var y1 = max<num>(this.y, rectangle.y);
      var y2 = min<num>(this.y + this.height, rectangle.y + rectangle.height);

      this.x = x1;
      this.width = max<num>(x2 - x1, 0);
      this.y = y1;
      this.height = max<num>(y2 - y1, 0);
  }

  ceil([resolution = 1, eps = 0.001]){
        var x2 = ((this.x + this.width - eps) * resolution).ceil() / resolution;
        var y2 = ((this.y + this.height - eps) * resolution).ceil() / resolution;

        this.x = ((this.x + eps) * resolution).floor() / resolution;
        this.y = ((this.y + eps) * resolution).floor() / resolution;

        this.width = x2 - this.x;
        this.height = y2 - this.y;
  }

  enlarge(rectangle){
        var x1 = min<num>(this.x, rectangle.x);
        var x2 = max<num>(this.x + this.width, rectangle.x + rectangle.width);
        var y1 = min<num>(this.y, rectangle.y);
        var y2 = max<num>(this.y + this.height, rectangle.y + rectangle.height);

        this.x = x1;
        this.width = x2 - x1;
        this.y = y1;
        this.height = y2 - y1;
  }
}