import 'package:flutter_test/flutter_test.dart';
// import 'package:test_api/test_api.dart';
import '../math/Matrix.dart';
import '../math/Point.dart';

void main(){
  group('Matrix', (){
    test('Matrix fromList', (){
      final matrix = Matrix();
      matrix.fromList([1,2,3,4,5,6]);
      expect(matrix.a,1);
      expect(matrix.b,2);
      expect(matrix.c,4);
      expect(matrix.d,5);
      expect(matrix.tx,3);
      expect(matrix.ty,6);
    });

    test('Matrix toList', (){
      final matrix = Matrix(1,2,3,4,5,6);
      var result =matrix.toList(true);
      expect(result,[1,2,0,3,4,0,5,6,1]);
      var result2 = matrix.toList(false);
      expect(result2,[1,3,5,2,4,6,0,0,1]);
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
