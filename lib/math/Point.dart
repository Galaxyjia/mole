class Point{
  num x;
  num y;

  Point([x=0,y=0]){
    this.x=x;
    this.y=y;
  }

  ///a copy of the point
  clone(){
    return new Point(this.x, this.y);
  }
  
  ///Copies x and y from the given point
  copyFrom(p){
    this.set(p.x, p.y);

    return this;
  }

  ///p - The point to copy.
  ///Given point with values updated
  copyTo(p){
    p.set(this.x, this.y);

    return p;
  }

  ///p - The point to check
  ///Whether the given point equal to this point
  equals(p)
  {
    return (p.x == this.x) && (p.y == this.y);
  }

  set(x, y){
    this.x = x ?? 0;
    this.y = y ?? ((y != 0) ? this.x : 0);
  }

}