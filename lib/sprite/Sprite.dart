import 'dart:ui';
import 'package:flutter/material.dart' show Colors;
import '../display/Group.dart';
import '../mole.dart';
import '../texture/basetexture.dart';
import '../utils/data/sign.dart';

class Sprite extends Group{
  BaseTexture texture;
  Image image;
  Rect src;
  Rect dst;
  double _width;
  double _height;

  static final Paint paint = new Paint()..color = Colors.white;

  Sprite(String fileName, {double x = 0.0, double y = 0.0, double width, double height }){
    Mole.images.load(fileName).then((img) {
        width??= img.width.toDouble();
        height??= img.height.toDouble();
        this.image = img;
        this.src = new Rect.fromLTWH(x, y, width, height);
    });
  }

  Sprite.fromImage(this.image) {
    this.src = new Rect.fromLTWH(0.0, 0.0, image.width.toDouble(), image.height.toDouble());
  }

  Sprite.fromTexture(BaseTexture texture){
    this.texture = texture;
    this.src = texture.src;
    this.image = texture.image;
    this.x = texture.x;
    this.y = texture.y;
  }

  bool loaded() {
    return this.image != null && this.src != null;
  }

  void update(double t){

  }

  get swidth{
    return this._width??this.image.width;
  }

  set swidth(value){
    this._width= value;
  }

  get sheight{
    return this._height??this.image.height;
  }

  set sheight(value){
    this._height= value;
  }

  get width{
    return (this.scale.x).abs()*this.image.width;
  }

  set width(value){
      final s = sign(this.scale.x)??1.0;
      this.scale.x = s*value/this.image.width;
      this._width = value;
  }

  get height{
    return (this.scale.y).abs()*this.image.height;
  }

  set height(value){
      final s = sign(this.scale.y)??1.0;
      this.scale.y = s*value/this.image.height;
      this._height = value;
  }





  void render(Canvas canvas){
    if (this.loaded()) {
      // Rect dst = new Rect.fromLTWH(this.x.toDouble(),this.y.toDouble(), this.swidth.toDouble(),this.sheight.toDouble());
      Rect dst = new Rect.fromLTWH(this.x.toDouble(),this.y.toDouble(), this.width.toDouble(),this.height.toDouble());
      canvas.drawImageRect(this.image, this.src, dst, paint);
    }
  }
}