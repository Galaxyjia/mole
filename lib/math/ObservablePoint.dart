import './Point.dart';

class ObservablePoint{
  dynamic scope;
  num _x;
  num _y;
  String flag;
  // num x;
  // num y;

  ///scope - owner of callback,在scope中重写onChange函数作为回调。
  ///x - position of the point on the x axis
  ///y - position of the point on the y axis
  ///flag为回调标签，可以在onChange函数中根据标签进行判断。
  ObservablePoint(scope,[x=0.0,y=0.0,flag="onChange"]){
    this._x=x;
    this._y=y;
    this.flag=flag;
    this.scope=scope;
  }

  clone(scope,flag){
    var _flag = flag??this.flag;
    var _scope = scope??this.scope;
    return new ObservablePoint(_scope,this._x, this._y,_flag);
  }
  
  copyFrom(Point p){
    if (this._x != p.x || this._y != p.y){
            this._x = p.x;
            this._y = p.y;
            ///执行scope的onChange回调，根据传入参数判断类型
            this.scope.onChange(this.flag);
    }

    return this;
  }
  ///Given point with values updated
  copyTo(Point p){
    p.set(this._x, this._y);

    return p;
  }

  ///Whether the given point equal to this point
  equals(Point p)
  {
    return (p.x == this._x) && (p.y == this._y);
  }

  ///Sets the point to a new x and y position.
  ///If y is omitted, both x and y will be set to x.
  set(x, y){
    var _x = x ?? 0.0;
    var _y = y ?? ((y != 0.0) ? _x : 0.0);

    if (this._x != _x || this._y != _y){
            this._x = _x;
            this._y = _y;
            this.scope.onChange(this.flag);
    }
  }

  ///The position of the displayObject on the x axis relative to the local coordinates of the parent.
  get x {
        return this._x;
  }

  set x(value){
    if (this._x != value){
        this._x = value;
        this.scope.onChange(this.flag);
    }
  }

  get y {
        return this._y;
  }

  set y(value){
    if (this._y != value){
        this._y = value;
        this.scope.onChange(this.flag);
    }
  }
  
}