// import 'package:flutter/material.dart';

import './DisplayObject.dart';
import 'dart:core';
import 'dart:ui';
import '../settings/settings.dart';

sortChildren(a, b){
    if (a.zIndex == b.zIndex){
        return a._lastSortedIndex - b._lastSortedIndex;
    }

    return a.zIndex - b.zIndex;
}

class Group extends DisplayObject{
  List children;
  bool sortDirty;
  bool sortableChildren;
  Group():super(){
    this.children = [];
    this.sortableChildren = settings['SORTABLE_CHILDREN'];
    this.sortDirty = false;
  }

  onChildrenChange(num index){}

  ///暂只提供一次添加一个child的方法，动态参数个数Todo。
  addChild(child){
    if(child.parent!=null){
      child.parent.removeChild(child);
    }
    child.parent = this;
    this.children.add(child);

    return child;
  }

  removeChild(child){
    this.children.remove(child);
    return child;
  }

  sortChildren(){
        var sortRequired = false;

        for (var i = 0, j = this.children.length; i < j; ++i)
        {
            var child = this.children[i];

            child._lastSortedIndex = i;

            if (!sortRequired && child.zIndex != 0)
            {
                sortRequired = true;
            }
        }

        if (sortRequired && this.children.length > 1)
        {
            this.children.sort(sortChildren());
        }

        this.sortDirty = false;
  }

  updateTransform(){
        if (this.sortableChildren && this.sortDirty){
            this.sortChildren();
        }

        this.plusBoundsID();

        this.transform.updateTransform(this.parent.transform);

        // TODO: check render flags, how to process stuff here
        this.worldAlpha = this.alpha * this.parent.worldAlpha;

        for (var i = 0, j = this.children.length; i < j; ++i){
            var child = this.children[i];

            if (child.visible){
                child.updateTransform();
            }
        }
  }

  @override
  calculateBounds(){
        ///清空Bounds
        print('calculateBounds');

        this.clearBounds();

        this._calculateBounds();

        for (var i = 0; i < this.children.length; i++){
            var child = this.children[i];

            if (!child.visible){
                continue;
            }

            child.calculateBounds();

            // TODO: filter+mask, need to mask both somehow
            // if (child._mask){
            //     child._mask.calculateBounds();
            //     this._bounds.addBoundsMask(child._bounds, child._mask._bounds);
            // }else if (child.filterArea){
            //     this._bounds.addBoundsArea(child._bounds, child.filterArea);
            // }else{
            //     this._bounds.addBounds(child._bounds);
            // }
            this.bounds.addBounds(child.bounds);
        }

        this.equalToLastBoundsID();
  }

  ///重新计算对象边界，重写特殊对象
  _calculateBounds(){

  }

  _render(Canvas canvas){
    ///this is where content itself gets rendered...
    
  }

  @override
  render(Canvas canvas){
        // if the object is not visible or the alpha is 0 then no need to render this element
        if (!this.visible || this.worldAlpha <= 0){
            return;
        }

        this._render(canvas);

            // simple render children!
        for (var i = 0, j = this.children.length; i < j; ++i){
          ///增加了是否可见判断
                if(this.children[i].visible == true){
                    this.children[i].render(canvas);
                }
        }
  }
}
