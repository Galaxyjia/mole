import 'dart:ui';
import './Group.dart';
import './Bounds.dart';
import '../math/Transform.dart';
import '../math/shapes/Rectangle.dart';

class DisplayObject {
  Group tempDisplayObjectParent;
  Transform transform;

  num alpha;
  bool visible;
  Group parent;
  num worldAlpha;

  num _zIndex;
  Bounds _bounds;
  num _boundsID;
  num _lastBoundsID;
  Rectangle _boundsRect;
  Rectangle _localBoundsRect;
  bool interactive;
  bool interactiveChildren;

  DisplayObject(){
    this.tempDisplayObjectParent = null;
    this.transform = new Transform();

    this.alpha =1;
    this.visible=true;
    this.parent = null;
    this.worldAlpha=1;

    this._zIndex = 0;
    this._bounds = new Bounds();
    this._boundsID = 0;
    this._lastBoundsID = -1;
    this._boundsRect = null;
    this._localBoundsRect = null;

    this.interactive = false;

  }

  ///临时父容器
  get _tempDisplayObjectParent{
    if (this.tempDisplayObjectParent == null){
            this.tempDisplayObjectParent = new Group();
    }

    return this.tempDisplayObjectParent;
  }

  ///根据父矩阵更新自身父坐标系和世界坐标系
  updateTransform(){
        this.transform.updateTransform(this.parent.transform);
        // multiply the alphas..
        this.worldAlpha = this.alpha * this.parent.worldAlpha;

        this.plusBoundsID();
  }

  ///递归计算并更新矩阵
  recursivePostUpdateTransform(){
    if (this.parent!=null){
            this.parent.recursivePostUpdateTransform();
            this.transform.updateTransform(this.parent.transform);
    }else{
            this.transform.updateTransform(this._tempDisplayObjectParent.transform);
    }
  }

  ///[skipUpdate] - Setting to `true` will stop the transforms of the scene graph from
  /// being updated. This means the calculation returned MAY be out of date BUT will give you a
  ///nice performance boost.
  ///[rect] - Optional rectangle to store the result of the bounds calculation.
  ///return [Rectangle] The rectangular bounding area.
  getBounds([bool skipUpdate=false,Rectangle rect]){
        if (skipUpdate == true){
            if (this.parent==null){
                this.parent = this._tempDisplayObjectParent;
                this.updateTransform();
                this.parent = null;
            }else{
                this.recursivePostUpdateTransform();
                this.updateTransform();
            }
        }

        if (this._boundsID != this._lastBoundsID){
            print(_boundsID);
            print(_lastBoundsID);
            this.calculateBounds();
            this._lastBoundsID = this._boundsID;
        }

        if (rect==null){
            if (this._boundsRect ==null){
                this._boundsRect = new Rectangle();
            }

            rect = this._boundsRect;
        }

        return this._bounds.getRectangle(rect);
  }

  getLocalBounds([Rectangle rect]){
        var transformRef = this.transform;
        var parentRef = this.parent;

        this.parent = null;
        this.transform = this._tempDisplayObjectParent.transform;

        if (rect == null){
            if (this._localBoundsRect==null){
                this._localBoundsRect = new Rectangle();
            }

            rect = this._localBoundsRect;
        }

        var bounds = this.getBounds(false, rect);

        this.parent = parentRef;
        this.transform = transformRef;

        return bounds;
  }

  toGlobal(position,[point, skipUpdate = false]){
    if (skipUpdate == true){
            this.recursivePostUpdateTransform();

            // this parent check is for just in case the item is a root object.
            // If it is we need to give it a temporary parent so that displayObjectUpdateTransform works correctly
            // this is mainly to avoid a parent check in the main loop. Every little helps for performance :)
            if (this.parent==null){
                this.parent = this._tempDisplayObjectParent;
                this.displayObjectUpdateTransform();
                this.parent = null;
            }
            else
            {
                this.displayObjectUpdateTransform();
            }
    }

        // don't need to update the lot
        // return this.worldTransform.apply(position, point);
        return this.worldTransform(position,point);
  }


  plusBoundsID(){
    this._boundsID++;
  }

  clearBounds(){
    this._bounds.clear();
  }
  
  equalToLastBoundsID(){
    this._lastBoundsID = this._boundsID;
  }

  ///重写
  render(Canvas canvas){

  }

  ///重写,ObervablePoint改变时调用,flag为回传参数用于判断状态
  onChange(flag){

  }

  ///重写,Container重写边界计算
  calculateBounds(){
     
  }

  ///重写，ParticleContainer
  displayObjectUpdateTransform(){

  }

  setTransform({x = 0.0, y = 0.0, scaleX = 1.0, scaleY = 1.0, rotation = 0.0, skewX = 0.0, skewY = 0.0, pivotX = 0.0, pivotY = 0.0}){
        this.position.x = x;
        this.position.y = y;
        this.scale.x = scaleX??1.0;
        this.scale.y = scaleY??1.0;
        this.rotation = rotation;
        this.skew.x = skewX;
        this.skew.y = skewY;
        this.pivot.x = pivotX;
        this.pivot.y = pivotY;

        return this;
  }

  get bounds{
    return this._bounds;
  }

  set bounds(value){
    this._bounds=value;
  }

  get x{
    return this.position.x;
  }

  set x(double value){
    this.transform.position.x = value;
  }

  get y {
    return this.position.y;
  }

  set y(double value){
    this.transform.position.y = value;
  }

  get worldTransform{
    return this.transform.worldTransform;
  }

  get localTransform{
    return this.transform.localTransform;
  }

  get position{
    return this.transform.position;
  }
  
  set position(value){
    this.transform.position.copyFrom(value);
  }
  
  get scale{
    return this.transform.scale;
  }

  set scale(value){
    this.transform.scale.copyFrom(value);
  }

  get pivot{
    return this.transform.pivot;
  }

  set pivot(value){
    this.transform.pivot.copyFrom(value);
  }

  get skew{
    return this.transform.skew;
  }

  set skew(value){
    this.transform.skew.copyFrom(value);
  }

  get rotation{
    return this.transform.rotation;
  }

  set rotation(value){
    this.transform.rotation = value;
  }

  // get angle{
  //   return this.transform.rotation * RAD_TO_DEG;
  // }

  // set angle(value){
  //   this.transform.rotation = value * DEG_TO_RAD;
  // }

  // get zIndex{
  //   return this._zIndex;
  // }

  // set zIndex(value){
  //   this._zIndex = value;
  //       if (this.parent!=null){
  //           this.parent.sortDirty = true;
  //       }
  // }

  // get worldVisible{
  //       var item = this;

  //       do{
  //           if (!item.visible){
  //               return false;
  //           }

  //           // item = item.parent;
  //       } while (item!=null);

  //       return true;
  // }

}