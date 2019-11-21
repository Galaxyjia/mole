import './Point.dart';
import './const.dart' show PI_2;
import 'dart:math' as math show cos,sin,atan2,sqrt;

class Matrix{
  double a;
  double b;
  double c;
  double d;
  double tx;
  double ty;
  List list;

  /// |a|c|tx|
  /// |b|d|ty|
  /// |0|0|1 |
  /// a - x scale         
  /// b - x skew           
  /// c - y skew
  /// d - y scale
  /// tx - x translation
  /// ty - y translation
  Matrix([a=1.0,b=0.0,c=0.0,d=1.0,tx=0.0,ty=0.0]){
    this.a = a;
    this.b = b;
    this.c = c;
    this.d = d;
    this.tx = tx;
    this.ty = ty;
    this.list = null;
  }

  ///The array that the matrix will be populated from.
  ///List x scale, x skew, x translation , y scale, y skew, y translation
  fromList(List list){
    this.a = list[0];
    this.b = list[1];
    this.c = list[3];
    this.d = list[4];
    this.tx = list[2];
    this.ty = list[5];
  }

  ///This matrix. Good for chaining method calls.
  set(double a,double b,double c,double d,double tx,double ty){
    this.a = a;
    this.b = b;
    this.c = c;
    this.d = d;
    this.tx = tx;
    this.ty = ty;
    return this;
  }

  ///bool transpose 是否需要转置矩阵
  ///If provided the array will be assigned to out
  ///[return] the newly created array which contains the matrix
  toList(bool transpose,[List out]){
    if(this.list==null){
      this.list = new List(9);
    }
    var list = out??this.list;

    if(transpose){
      list[0] = this.a;
      list[1] = this.b;
      list[2] = 0.0;
      list[3] = this.c;
      list[4] = this.d;
      list[5] = 0.0;
      list[6] = this.tx;
      list[7] = this.ty;
      list[8] = 1.0;
    }else{
      list[0] = this.a;
      list[1] = this.c;
      list[2] = this.tx;
      list[3] = this.b;
      list[4] = this.d;
      list[5] = this.ty;
      list[6] = 0;
      list[7] = 0;
      list[8] = 1;
    }

    return list;
  }

  ///[point] pos - The origin
  ///[newPos] - The point that the new position is assigned to (allowed to be same as input)
  ///[return] The new point, transformed through this matrix
  ///应用当前矩阵后的新位置
  ///可以被用在子坐标系向世界坐标系转换
  apply(Point pos,[Point newPos]){
      newPos = newPos ?? new Point();

      var x = pos.x;
      var y = pos.y;

      newPos.x = (this.a * x) + (this.c * y) + this.tx;
      newPos.y = (this.b * x) + (this.d * y) + this.ty;

      return newPos;
  }
  
  ///世界坐标向相对坐标转换
  applyInverse(Point pos,[Point newPos]){
      newPos = newPos ?? new Point();

      var id = 1 / ((this.a * this.d) + (this.c * -this.b));

      var x = pos.x;
      var y = pos.y;

      newPos.x = (this.d * id * x) + (-this.c * id * y) + (((this.ty * this.c) - (this.tx * this.d)) * id);
      newPos.y = (this.a * id * y) + (-this.b * id * x) + (((-this.ty * this.a) + (this.tx * this.b)) * id);

      return newPos;
  }


  translate(double x,double y){
      this.tx += x;
      this.ty += y;

      return this;
  }

  scale(double x,double y){
      this.a *= x;
      this.d *= y;
      this.c *= x;
      this.b *= y;
      this.tx *= x;
      this.ty *= y;

      return this;
  }

  ///angle为弧度
  rotate(double angle){
      var cos;
      var sin;
      cos = math.cos(angle);
      sin = math.sin(angle);

      var a1 = this.a;
      var c1 = this.c;
      var tx1 = this.tx;

      this.a = (a1 * cos) - (this.b * sin);
      this.b = (a1 * sin) + (this.b * cos);
      this.c = (c1 * cos) - (this.d * sin);
      this.d = (c1 * sin) + (this.d * cos);
      this.tx = (tx1 * cos) - (this.ty * sin);
      this.ty = (tx1 * sin) + (this.ty * cos);

      return this;
  }
  
  ///appends the given Matrix to this Matrix
  ///matrix - The matrix to append.
  append(Matrix matrix){
        var a1 = this.a;
        var b1 = this.b;
        var c1 = this.c;
        var d1 = this.d;

        this.a = (matrix.a * a1) + (matrix.b * c1);
        this.b = (matrix.a * b1) + (matrix.b * d1);
        this.c = (matrix.c * a1) + (matrix.d * c1);
        this.d = (matrix.c * b1) + (matrix.d * d1);

        this.tx = (matrix.tx * a1) + (matrix.ty * c1) + this.tx;
        this.ty = (matrix.tx * b1) + (matrix.ty * d1) + this.ty;

        return this;
    }
  
  /// Sets the matrix based on all the available properties
  /// @param {number} x - Position on the x axis
  /// @param {number} y - Position on the y axis
  /// @param {number} pivotX - Pivot on the x axis
  /// @param {number} pivotY - Pivot on the y axis
  /// @param {number} scaleX - Scale on the x axis
  /// @param {number} scaleY - Scale on the y axis
  /// @param {number} rotation - Rotation in radians
  /// @param {number} skewX - Skew on the x axis
  /// @param {number} skewY - Skew on the y axis
  ///  @return {PIXI.Matrix} This matrix. Good for chaining method calls.
  setTransform(double x, double y,double pivotX,double pivotY,double scaleX,double scaleY,double rotation,double skewX,double skewY){
        this.a = math.cos(rotation + skewY) * scaleX;
        this.b = math.sin(rotation + skewY) * scaleX;
        this.c = -math.sin(rotation - skewX) * scaleY;
        this.d = math.cos(rotation - skewX) * scaleY;

        this.tx = x - ((pivotX * this.a) + (pivotY * this.c));
        this.ty = y - ((pivotX * this.b) + (pivotY * this.d));

        return this;
    }

  ///
  prepend(matrix){
        var tx1 = this.tx;

        if (matrix.a != 1 || matrix.b != 0 || matrix.c != 0 || matrix.d != 1)
        {
            var a1 = this.a;
            var c1 = this.c;

            this.a = (a1 * matrix.a) + (this.b * matrix.c);
            this.b = (a1 * matrix.b) + (this.b * matrix.d);
            this.c = (c1 * matrix.a) + (this.d * matrix.c);
            this.d = (c1 * matrix.b) + (this.d * matrix.d);
        }

        this.tx = (tx1 * matrix.a) + (this.ty * matrix.c) + matrix.tx;
        this.ty = (tx1 * matrix.b) + (this.ty * matrix.d) + matrix.ty;

        return this;
    }

    decompose(transform){
        // sort out rotation / skew..
        var a = this.a;
        var b = this.b;
        var c = this.c;
        var d = this.d;

        var skewX = -math.atan2(-c, d);
        var skewY = math.atan2(b, a);

        var delta = (skewX + skewY).abs();

        if (delta < 0.00001 || (PI_2 - delta).abs() < 0.00001)
        {
            transform.rotation = skewY;
            transform.skew.x = transform.skew.y = 0;
        }
        else
        {
            transform.rotation = 0;
            transform.skew.x = skewX;
            transform.skew.y = skewY;
        }

        // next set scale
        transform.scale.x = math.sqrt((a * a) + (b * b));
        transform.scale.y = math.sqrt((c * c) + (d * d));

        // next set position
        transform.position.x = this.tx;
        transform.position.y = this.ty;

        return transform;
    }

    ///反转矩阵
    invert(){
        var a1 = this.a;
        var b1 = this.b;
        var c1 = this.c;
        var d1 = this.d;
        var tx1 = this.tx;
        var n = (a1 * d1) - (b1 * c1);

        this.a = d1 / n;
        this.b = -b1 / n;
        this.c = -c1 / n;
        this.d = a1 / n;
        this.tx = ((c1 * this.ty) - (d1 * tx1)) / n;
        this.ty = -((a1 * this.ty) - (b1 * tx1)) / n;
        return this;
    }

    ///重置矩阵初始值
    identity(){
        this.a = 1.0;
        this.b = 0.0;
        this.c = 0.0;
        this.d = 1.0;
        this.tx = 0.0;
        this.ty = 0.0;

        return this;
    }  

    /// 拷贝一个具有相同数据的新矩阵
    clone(){
        var matrix = new Matrix();

        matrix.a = this.a;
        matrix.b = this.b;
        matrix.c = this.c;
        matrix.d = this.d;
        matrix.tx = this.tx;
        matrix.ty = this.ty;

        return matrix;
    }

    ///将当前矩阵数据拷贝到目标矩阵
    copyTo(matrix){
        matrix.a = this.a;
        matrix.b = this.b;
        matrix.c = this.c;
        matrix.d = this.d;
        matrix.tx = this.tx;
        matrix.ty = this.ty;

        return matrix;
    }

    ///更新矩阵值与目标矩阵相同
    copyFrom(matrix){
        this.a = matrix.a;
        this.b = matrix.b;
        this.c = matrix.c;
        this.d = matrix.d;
        this.tx = matrix.tx;
        this.ty = matrix.ty;

        return this;
    }

    ///默认矩阵IDENTITY
    static identityMarix(){
      return new Matrix();
    }

    ///临时矩阵
    static tempMarix(){
        return new Matrix();
    }

}