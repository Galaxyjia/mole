import 'package:flutter/material.dart';
import 'dart:ui' as ui ;
import 'package:rxdart/rxdart.dart';
import 'dart:async';

import '../display/DisplayObject.dart';

// class Text{
//     ui.Paragraph text(String text, { double fontSize = 24.0, Color color = Colors.white, fontFamily: 'Arial', double maxWidth = 180.0 }) {
//     ui.ParagraphBuilder paragraph = new ui.ParagraphBuilder(new ui.ParagraphStyle());
//     paragraph.pushStyle(new ui.TextStyle(color: color, fontSize: fontSize, fontFamily: fontFamily));
//     paragraph.addText(text);
//     return paragraph.build()..layout(new ui.ParagraphConstraints(width: maxWidth));
//   }
// }

class Text extends DisplayObject{
    String text='';

    Text({this.text}):super();

    ui.Paragraph draw(String text, { double fontSize = 24.0, Color color = Colors.black, fontFamily: 'Arial', double maxWidth = 180.0 }) {
        ui.ParagraphBuilder paragraph = new ui.ParagraphBuilder(new ui.ParagraphStyle());
        paragraph.pushStyle(new ui.TextStyle(color: color, fontSize: fontSize, fontFamily: fontFamily));
        paragraph.addText(text);
        return paragraph.build()..layout(new ui.ParagraphConstraints(width: maxWidth));
    }

      ///打字机效果
    showText(String str){
          // String str="床前明月光，疑是地上霜。举头望明月，低头思故乡。";
          var words = str.split('');
          var obs1 = new Observable(new Stream.fromIterable(words))
          .interval(new Duration(milliseconds:200))
          // .map((String oneItem)=>oneItem = oneItem.toUpperCase())
          // .expand((String oneItem)=>[oneItem,oneItem.split('')])
          .listen((val){
            this.text+=val;
          });
    }

    render(Canvas canvas){
      canvas.drawParagraph(draw(this.text), Offset(this.x,this.y));
    }
}