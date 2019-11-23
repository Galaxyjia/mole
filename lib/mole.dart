library mole;

import 'package:mole/base/Text.dart';
import 'package:mole/display/DisplayObject.dart';
import 'package:mole/display/Group.dart';

import './utils/Util.dart';
import './base/Images.dart';
import './utils/Resources.dart';

class Mole{
  static Util util = new Util();
  static Images images = new Images();
  static Resources resources = new Resources();
  static DisplayObject displayObject = new DisplayObject();
  static Group group = new Group();
  static Text text = new Text();
}
