import '../math/shapes/Rectangle.dart';
import 'dart:math';

class Bounds{
  num minX;
  num minY;
  num maxX;
  num maxY;
  Rectangle rect;
  num updateID;

  Bounds(){
    this.minX =0;
    this.minY =0;
    this.maxX =0;
    this.maxY = 0;
    this.rect = null;
  }

  ///是否为空
  isEmpty(){
    return this.minX>this.maxX??this.minY>this.maxX;
  }

  ///清除
  clear(){
    this.updateID++;
    ///infinity正无穷大
    this.minX = double.infinity;
    this.minY = double.infinity;
    this.maxX = double.negativeInfinity;
    this.maxY = double.negativeInfinity;
  }

  ///可以返回Rectangle.empty常量，或者构造新的矩形，或者使用你的矩形
  ///rect - 如果AABB不为空，将使用临时对象
  ///举行边界
  getRectangle(Rectangle rect){
    if (this.minX > this.maxX || this.minY > this.maxY){
        return Rectangle.empty;
    }

    rect = rect ?? new Rectangle(0, 0, 1, 1);

    rect.x = this.minX;
    rect.y = this.minY;
    rect.width = this.maxX - this.minX;
    rect.height = this.maxY - this.minY;

    return rect;
  }

  ///此功能应尽可能内联。
  ///要添加的点。
  addPoint(point){
    this.minX = min<num>(this.minX, point.x);
    this.maxX = max<num>(this.maxX, point.x);
    this.minY = min<num>(this.minY, point.y);
    this.maxY = max<num>(this.maxY, point.y);
  }

  ///Adds a quad, not transformed
  ///添加四边形，未转换
  ///添加顶点
  ///{Float32Array} vertices - The verts to add
  addQuad(vertices){
        var minX = this.minX;
        var minY = this.minY;
        var maxX = this.maxX;
        var maxY = this.maxY;

        var x = vertices[0];
        var y = vertices[1];

        minX = x < minX ? x : minX;
        minY = y < minY ? y : minY;
        maxX = x > maxX ? x : maxX;
        maxY = y > maxY ? y : maxY;

        x = vertices[2];
        y = vertices[3];
        minX = x < minX ? x : minX;
        minY = y < minY ? y : minY;
        maxX = x > maxX ? x : maxX;
        maxY = y > maxY ? y : maxY;

        x = vertices[4];
        y = vertices[5];
        minX = x < minX ? x : minX;
        minY = y < minY ? y : minY;
        maxX = x > maxX ? x : maxX;
        maxY = y > maxY ? y : maxY;

        x = vertices[6];
        y = vertices[7];
        minX = x < minX ? x : minX;
        minY = y < minY ? y : minY;
        maxX = x > maxX ? x : maxX;
        maxY = y > maxY ? y : maxY;

        this.minX = minX;
        this.minY = minY;
        this.maxX = maxX;
        this.maxY = maxY;
  }

  ///Adds sprite frame, transformed.
  addFrame(transform, x0, y0, x1, y1){
        var matrix = transform.worldTransform;
        var a = matrix.a;
        var b = matrix.b;
        var c = matrix.c;
        var d = matrix.d;
        var tx = matrix.tx;
        var ty = matrix.ty;

        var minX = this.minX;
        var minY = this.minY;
        var maxX = this.maxX;
        var maxY = this.maxY;

        var x = (a * x0) + (c * y0) + tx;
        var y = (b * x0) + (d * y0) + ty;

        minX = x < minX ? x : minX;
        minY = y < minY ? y : minY;
        maxX = x > maxX ? x : maxX;
        maxY = y > maxY ? y : maxY;

        x = (a * x1) + (c * y0) + tx;
        y = (b * x1) + (d * y0) + ty;
        minX = x < minX ? x : minX;
        minY = y < minY ? y : minY;
        maxX = x > maxX ? x : maxX;
        maxY = y > maxY ? y : maxY;

        x = (a * x0) + (c * y1) + tx;
        y = (b * x0) + (d * y1) + ty;
        minX = x < minX ? x : minX;
        minY = y < minY ? y : minY;
        maxX = x > maxX ? x : maxX;
        maxY = y > maxY ? y : maxY;

        x = (a * x1) + (c * y1) + tx;
        y = (b * x1) + (d * y1) + ty;
        minX = x < minX ? x : minX;
        minY = y < minY ? y : minY;
        maxX = x > maxX ? x : maxX;
        maxY = y > maxY ? y : maxY;

        this.minX = minX;
        this.minY = minY;
        this.maxX = maxX;
        this.maxY = maxY;
  }
  ///{Float32Array} vertexData - calculated vertices
  ///{number} beginOffset - begin offset
  ///{number} endOffset - end offset, excluded
  addVertexData(vertexData,num beginOffset,num endOffset){
        var minX = this.minX;
        var minY = this.minY;
        var maxX = this.maxX;
        var maxY = this.maxY;

        for (var i = beginOffset; i < endOffset; i += 2)
        {
            var x = vertexData[i];
            var y = vertexData[i + 1];

            minX = x < minX ? x : minX;
            minY = y < minY ? y : minY;
            maxX = x > maxX ? x : maxX;
            maxY = y > maxY ? y : maxY;
        }

        this.minX = minX;
        this.minY = minY;
        this.maxX = maxX;
        this.maxY = maxY;
  }

  addVertices(transform, vertices, beginOffset, endOffset){
        var matrix = transform.worldTransform;
        var a = matrix.a;
        var b = matrix.b;
        var c = matrix.c;
        var d = matrix.d;
        var tx = matrix.tx;
        var ty = matrix.ty;

        var minX = this.minX;
        var minY = this.minY;
        var maxX = this.maxX;
        var maxY = this.maxY;

        for (var i = beginOffset; i < endOffset; i += 2)
        {
            var rawX = vertices[i];
            var rawY = vertices[i + 1];
            var x = (a * rawX) + (c * rawY) + tx;
            var y = (d * rawY) + (b * rawX) + ty;

            minX = x < minX ? x : minX;
            minY = y < minY ? y : minY;
            maxX = x > maxX ? x : maxX;
            maxY = y > maxY ? y : maxY;
        }

        this.minX = minX;
        this.minY = minY;
        this.maxX = maxX;
        this.maxY = maxY;
  }

  ///计算bounds然后得出新的Bounds
  addBounds(bounds){
        print('addBounds');
        var minX = this.minX;
        var minY = this.minY;
        var maxX = this.maxX;
        var maxY = this.maxY;

        this.minX = bounds.minX < minX ? bounds.minX : minX;
        this.minY = bounds.minY < minY ? bounds.minY : minY;
        this.maxX = bounds.maxX > maxX ? bounds.maxX : maxX;
        this.maxY = bounds.maxY > maxY ? bounds.maxY : maxY;
  }

  addBoundsMask(bounds, mask){
        var _minX = bounds.minX > mask.minX ? bounds.minX : mask.minX;
        var _minY = bounds.minY > mask.minY ? bounds.minY : mask.minY;
        var _maxX = bounds.maxX < mask.maxX ? bounds.maxX : mask.maxX;
        var _maxY = bounds.maxY < mask.maxY ? bounds.maxY : mask.maxY;

        if (_minX <= _maxX && _minY <= _maxY)
        {
            var minX = this.minX;
            var minY = this.minY;
            var maxX = this.maxX;
            var maxY = this.maxY;

            this.minX = _minX < minX ? _minX : minX;
            this.minY = _minY < minY ? _minY : minY;
            this.maxX = _maxX > maxX ? _maxX : maxX;
            this.maxY = _maxY > maxY ? _maxY : maxY;
        }
  }

  addBoundsArea(bounds, area){
        var _minX = bounds.minX > area.x ? bounds.minX : area.x;
        var _minY = bounds.minY > area.y ? bounds.minY : area.y;
        var _maxX = bounds.maxX < area.x + area.width ? bounds.maxX : (area.x + area.width);
        var _maxY = bounds.maxY < area.y + area.height ? bounds.maxY : (area.y + area.height);

        if (_minX <= _maxX && _minY <= _maxY)
        {
            var minX = this.minX;
            var minY = this.minY;
            var maxX = this.maxX;
            var maxY = this.maxY;

            this.minX = _minX < minX ? _minX : minX;
            this.minY = _minY < minY ? _minY : minY;
            this.maxX = _maxX > maxX ? _maxX : maxX;
            this.maxY = _maxY > maxY ? _maxY : maxY;
        }
  }

}