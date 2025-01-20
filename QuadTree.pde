class Quadtree {
  int capacity;
  ArrayList<Ball> balls;
  boolean divided;
  PVector position;
  float width_, height_;
  Quadtree northeast, northwest, southeast, southwest;
  PShape square;

  Quadtree(float x, float y, float w, float h, int n) {
    position = new PVector(x, y);
    width_ = w;
    height_ = h;
    capacity = n;
    balls = new ArrayList<Ball>();
    divided = false;
    //square = createShape(RECT, 0, 0, width_, height_);
    //square.setStroke(color(255,0,0));
  }

  void subdivide() {
    float x = position.x;
    float y = position.y;
    float w = width_ / 2;
    float h = height_ / 2;
    northeast = new Quadtree(x + w, y, w, h, capacity);
    northwest = new Quadtree(x, y, w, h, capacity);
    southeast = new Quadtree(x + w, y + h, w, h, capacity);
    southwest = new Quadtree(x, y + h, w, h, capacity);
    divided = true;
  }

  boolean insert(Ball b) {
    if (!contains(b)) {
      println("!contains(b)");
      return false;
    }

    if (balls.size() < capacity) {
      balls.add(b);
      println("Add to quadtree");
      return true;
    } else {
      if (!divided) {
        println("need to subdivide");
        subdivide();
      }
      if (northeast.insert(b) || northwest.insert(b) || southeast.insert(b) || southwest.insert(b)) {
        println("inserted into subtree");
        return true;
      }
    }
    return false;
  }

  boolean contains(Ball b) {
    return (b.sx >= position.x - width_ && b.sx < position.x + width_ &&
            b.sy >= position.y - height_ && b.sy < position.y + height_);
  }

  ArrayList<Ball> query(PVector rangePos, float rangeW, float rangeH) {
    ArrayList<Ball> found = new ArrayList<Ball>();

    if (!intersects(rangePos, rangeW, rangeH)) {
      return found;
    }

    for (Ball b : balls) {
      if (b.sx >= rangePos.x - rangeW && b.sx < rangePos.x + rangeW &&
          b.sy >= rangePos.y - rangeH && b.sy < rangePos.y + rangeH) {
        found.add(b);
      }
    }

    if (divided) {
      found.addAll(northeast.query(rangePos, rangeW, rangeH));
      found.addAll(northwest.query(rangePos, rangeW, rangeH));
      found.addAll(southeast.query(rangePos, rangeW, rangeH));
      found.addAll(southwest.query(rangePos, rangeW, rangeH));
    }

    return found;
  }

  boolean intersects(PVector rangePos, float rangeW, float rangeH) {
    return !(rangePos.x - rangeW > position.x + width_ || rangePos.x + rangeW < position.x - width_ ||
             rangePos.y - rangeH > position.y + height_ || rangePos.y + rangeH < position.y - height_);
  }

  void show() {
    stroke(color(255,255,0));
    noFill();
    //shape(square,position.x,position.y);
    rect(position.x, position.y, width_, height_);
    if (divided) {
      northeast.show();
      northwest.show();
      southeast.show();
      southwest.show();
    }
  }
}
