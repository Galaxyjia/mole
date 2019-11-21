import 'package:flutter_test/flutter_test.dart';

import '../display/Group.dart';
import '../LineBox.dart';

void main(){
  group('getBounds', (){
    test('getBounds', (){
      final parent = new Group();
      final lineBox = new LineBox();
      parent.addChild(lineBox);
      var bounds = lineBox.bounds.isEmpty();
      print(bounds);
      // print(bounds.x);
      // print(bounds.y);
      expect(bounds,false);
      // expect(bounds.x,100);
      // expect(bounds.y,100);

      // expect(bounds.width,60.0);
      // expect(bounds.height,60.0);

    });
  });
}
