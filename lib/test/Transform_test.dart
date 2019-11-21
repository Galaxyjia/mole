import 'package:flutter_test/flutter_test.dart';
// import 'package:test_api/test_api.dart';
import '../math/Matrix.dart';
import '../math/Point.dart';
import '../math/Transform.dart';

void main(){
  group('Transform', (){
    test('Transform postion', (){
      final transform = Transform();
      expect(transform.position.x,0);
      expect(transform.position.y,0);
    });

    test('Local Matrix', (){
      final transform = Transform();
      var localmatrix = Matrix(2,0,0,2,100,100);
      var lt = transform.localTransform;
      lt = localmatrix;
      var p1 = Point(100,100);

      var p2 =lt.apply(p1);
      expect(p2.x,300);
      expect(p2.y,300);
      // expect(transform.position.y,0);

    });

    test("apply points",(){
      final matrix = Matrix(1,2,3,4,5,6);
      var point = Point(1,1);
      var newpoint = matrix.apply(point);
      expect(newpoint.x,9);
      expect(newpoint.y,12);

      final matrix2 = Matrix(1,0,0,1,5,6);
      var point2 = Point(1,1);
      var newpoint2 = matrix2.apply(point2);
      expect(newpoint2.x,6);
      expect(newpoint2.y,7);

    });

    test("applyInverse points",(){
      final matrix = Matrix(1,0,0,1,5,6);
      var point = Point(6,7);
      var newpoint = matrix.applyInverse(point);
      expect(newpoint.x,1);
      expect(newpoint.y,1);

      final matrix2 = Matrix(1,0,0,1,6,7);
      var point2 = Point(6,7);
      var newpoint2 = matrix2.applyInverse(point2);
      expect(newpoint2.x,0);
      expect(newpoint2.y,0);
    });
    

    test("translate",(){
      final matrix = Matrix();
      var newmatrix = matrix.translate(1,1);
      expect(newmatrix.tx,1);
      expect(newmatrix.ty,1);
    });


    test("scale",(){
      final matrix = Matrix();
      var newmatrix = matrix.scale(2,2);
        expect(newmatrix.a,2);
        expect(newmatrix.b,0);
        expect(newmatrix.c,0);
        expect(newmatrix.d,2);
        expect(newmatrix.tx,0);
        expect(newmatrix.ty,0);
    });

    test("rotation",(){
      final matrix = Matrix();
      var newmatrix = matrix.rotate(3.1415926/2);
      expect(newmatrix.a,1.0);
      // expect(newmatrix.b,2);
      // expect(newmatrix.c,4);
      // expect(newmatrix.d,5);
      // expect(newmatrix.tx,3);
      // expect(newmatrix.ty,6);
    });    

  });
}
