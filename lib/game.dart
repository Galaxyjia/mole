import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import 'math/Point.dart';

abstract class Game {
  Function callback;

  final builder = WidgetBuilder();

  // void update(double t);
  void tickStart(callback){
    this.callback = callback;
  }

  void render(Canvas canvas);

  void resize(Size size) {}

  void lifecycleStateChange(AppLifecycleState state) {}

  void _recordDt(double dt) {}

  Widget get widget => builder.build(this);
}

class WidgetBuilder {
  Offset offset = Offset.zero;
  Widget build(Game game) => Directionality(
      textDirection: TextDirection.ltr, child: EmbeddedGameWidget(game));
}

class EmbeddedGameWidget extends LeafRenderObjectWidget {
  final Game game;
  final Point size;
  EmbeddedGameWidget(this.game, {this.size});

  @override
  RenderBox createRenderObject(BuildContext context) {
    return RenderConstrainedBox(
        child: GameRenderBox(context, game),
        additionalConstraints:
            BoxConstraints.expand(width: size?.x, height: size?.y));
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderConstrainedBox renderBox){
    renderBox
      ..child = GameRenderBox(context, game)
      ..additionalConstraints =
          BoxConstraints.expand(width: size?.x, height: size?.y);
  }
}


///使用WidgetsBindingObserver监听生命周期
class GameRenderBox extends RenderBox with WidgetsBindingObserver {
  BuildContext context;

  Game game;

  int _frameCallbackId;

  Duration previous = Duration.zero;

  GameRenderBox(this.context, this.game);

  @override
  bool get sizedByParent => true;

  @override
  void performResize(){
    super.performResize();
    game.resize(constraints.biggest);
  }

  /// 桥接到pipelineOwner
  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _scheduleTick();
    _bindLifecycleListener();
  }

  ///分离
  @override
  void detach() {
    super.detach();
    _unscheduleTick();
    _unbindLifecycleListener();
  }

  void _scheduleTick() {
    _frameCallbackId = SchedulerBinding.instance.scheduleFrameCallback(_tick);
  }

  void _unscheduleTick() {
    SchedulerBinding.instance.cancelFrameCallbackWithId(_frameCallbackId);
  }

  void _tick(Duration timestamp) {
    if (!attached) {
      return;
    }
    _scheduleTick();
    _update(timestamp);
    markNeedsPaint();
  }

  void _update(Duration now) {
    final double dt = _computeDeltaT(now);
    game._recordDt(dt);
    game.callback(dt);
    // game.update(dt);
  }

  double _computeDeltaT(Duration now) {
    Duration delta = now - previous;
    if (previous == Duration.zero) {
      delta = Duration.zero;
    }
    previous = now;
    return delta.inMicroseconds / Duration.microsecondsPerSecond;
  }


  ///canvas.save，restore避免对后面的绘制产生影响
  @override
  void paint(PaintingContext context, Offset offset) {
    context.canvas.save();
    context.canvas.translate(
        game.builder.offset.dx + offset.dx, game.builder.offset.dy + offset.dy);
    game.render(context.canvas);
    context.canvas.restore();
  }

  void _bindLifecycleListener() {
    WidgetsBinding.instance.addObserver(this);
  }

  void _unbindLifecycleListener() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    game.lifecycleStateChange(state);
  }

}

