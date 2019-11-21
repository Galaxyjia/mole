import 'ObservablePoint.dart';
import 'Matrix.dart';
import 'dart:math' show cos,sin;

class Transform{
  Matrix worldTransform;
  Matrix localTransform;
  ObservablePoint position;
  ObservablePoint scale;
  ObservablePoint pivot;
  ObservablePoint skew;
  double _rotation;
  double _cx;
  double _sx;
  double _cy;
  double _sy;
  num _localID;
  num _currentLocalID;
  num _worldID;
  num _parentID;

  Transform(){
    ///The world transformation matrix.
    this.worldTransform = new Matrix();

    ///The local transformation matrix.
    this.localTransform = new Matrix();

    ///The coordinate of the object relative to the local coordinates of the parent.
    ///对象相对与父坐标的点
    this.position = new ObservablePoint(this,0.0,0.0);

    ///The scale factor of the object.
    this.scale = new ObservablePoint(this,1.0,1.0);

    ///The pivot point of the displayObject that it rotates around.
    ///对象旋转的轴心点
    this.pivot = new ObservablePoint(this,0.0,0.0);

    this.skew = new ObservablePoint(this,0.0,0.0,"updateSkew");

    this._rotation =0.0;

    ///The X-coordinate value of the normalized local X axis,
    ///the first column of the local transformation matrix without a scale.
    /// 归一化的X轴
    /// 局部x坐标，局部矩阵第一列，没有缩放
    this._cx =1.0;

    this._sx = 0.0;

    this._cy = 0.0;

    this._sy= 1.0;

    ///The locally unique ID of the local transform
    this._localID =0;

    ///used to calculate the current local transformation matrix.
    this._currentLocalID =0;

    ///The locally unique ID of the world transform.
    this._worldID =0;

    ///The locally unique ID of the parent's world transform
    ///used to calculate the current world transformation matrix.
    this._parentID =0;
  }

  setParentID(){
    this._parentID = -1;
  }

  ///Called when a value changes.
  ///当Obervalepoint发生变化时调用。
  onChange(flag){
    // print('changed');
    if(flag == 'updateSkew'){
      this.updateSkew();
    }else{
      this._localID++;
    }
  }

  ///Called when the skew or the rotation changes.
  ///扭曲或旋转时调用
  updateSkew(){
    this._cx = cos(this._rotation + this.skew.y);
    this._sx = sin(this._rotation + this.skew.y);
    this._cy = -sin(this._rotation - this.skew.x); // cos, added PI/2
    this._sy = cos(this._rotation - this.skew.x); // sin, added PI/2
    this._localID++;
  }

  ///Updates the local transformation matrix.
  ///更新局部坐标矩阵
  updateLocalTransform(){
        var lt = this.localTransform;

        if (this._localID != this._currentLocalID){
            // get the matrix values of the displayobject based on its transform properties..
            lt.a = this._cx * this.scale.x;
            lt.b = this._sx * this.scale.x;
            lt.c = this._cy * this.scale.y;
            lt.d = this._sy * this.scale.y;

            lt.tx = this.position.x - ((this.pivot.x * lt.a) + (this.pivot.y * lt.c));
            lt.ty = this.position.y - ((this.pivot.x * lt.b) + (this.pivot.y * lt.d));
            this._currentLocalID = this._localID;

            // force an update..
            this._parentID = -1;
        }
  }

  /// Updates the local and the world transformation matrices.
  /// 更新局部和世界矩阵
  updateTransform(parentTransform){
        var lt = this.localTransform;

        if (this._localID != this._currentLocalID){
            /// get the matrix values of the displayobject based on its transform properties..
            lt.a = this._cx * this.scale.x;
            lt.b = this._sx * this.scale.x;
            lt.c = this._cy * this.scale.y;
            lt.d = this._sy * this.scale.y;

            lt.tx = this.position.x - ((this.pivot.x * lt.a) + (this.pivot.y * lt.c));
            lt.ty = this.position.y - ((this.pivot.x * lt.b) + (this.pivot.y * lt.d));
            this._currentLocalID = this._localID;

            /// force an update..
            this._parentID = -1;
        }

        if (this._parentID != parentTransform._worldID){
            /// concat the parent matrix with the objects transform.
            /// 父矩阵ID与世界ID不相等时
            /// 更新世界坐标
            var pt = parentTransform.worldTransform;
            var wt = this.worldTransform;

            wt.a = (lt.a * pt.a) + (lt.b * pt.c);
            wt.b = (lt.a * pt.b) + (lt.b * pt.d);
            wt.c = (lt.c * pt.a) + (lt.d * pt.c);
            wt.d = (lt.c * pt.b) + (lt.d * pt.d);
            wt.tx = (lt.tx * pt.a) + (lt.ty * pt.c) + pt.tx;
            wt.ty = (lt.tx * pt.b) + (lt.ty * pt.d) + pt.ty;

            this._parentID = parentTransform._worldID;

            // update the id of the transform..
            this._worldID++;
        }
    }

    ///Decomposes a matrix and sets the transforms properties based on it.
    setFromMatrix(matrix){
        matrix.decompose(this);
        this._localID++;
    }

    ///The rotation of the object in radians.
    get rotation {
        return this._rotation;
    }

    set rotation(value){
        if (this._rotation != value){
            this._rotation = value;
            this.updateSkew();
        }
    }

    static final identity = Transform();
}
