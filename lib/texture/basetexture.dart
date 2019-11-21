import '../base/Images.dart';
import '../mole.dart';
import 'dart:ui';

class BaseTexture{
  ///Image 为dart:ui里的Image对象
  Image image;
  Rect src;
  num x;
  num y;
  num width;
  num height;
  String type;

  BaseTexture(String fileName,[x,y,width,height]){
    init(fileName,x,y,width,height);
  }

  init(String fileName,[x,y,width,height]) async{
    final img =await Mole.images.load(fileName);
    this.image = img;
    this.x = x??0.0;
    this.y = y??0.0;
    this.width = width??img.width.toDouble();
    this.height = height??img.height.toDouble();
    this.src = new Rect.fromLTWH(this.x, this.y, this.width, this.height);
  }
}

// .then((img) {
//         this.x = x??0.0;
//         this.y = y??0.0;
//         this.width = width??img.width.toDouble();
//         this.height = height??img.height.toDouble();
//         this.image = img;
//         this.src = new Rect.fromLTWH(this.x, this.y, this.width, this.height);
//     }).whenComplete(()=>print('whenComplete'));