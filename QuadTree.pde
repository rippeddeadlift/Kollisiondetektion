class Quadtree {
  int capacity;
  ArrayList<Ball> balls;
  boolean divided;
  PVector position;
  float width, height;
  Quadtree northeast, northwest, southeast, southwest;

  Quadtree(float x, float y, float w, float h, int n) {
    position = new PVector(x, y);
    width = w;
    height = h;
    capacity = n;
    balls = new ArrayList<Ball>();
    divided = false;
  }

  void subdivide() {
    float x = position.x;
    float y = position.y;
    float w = width / 2;
    float h = height / 2;
    northeast = new Quadtree(x + w, y, w, h, capacity);
    northwest = new Quadtree(x, y, w, h, capacity);
    southeast = new Quadtree(x + w, y + h, w, h, capacity);
    southwest = new Quadtree(x, y + h, w, h, capacity);
    divided = true;
  }

  boolean insert(Ball b) {
    if (!contains(b)) {
      return false;
    }

    if (balls.size() < capacity) {
      balls.add(b);
      return true;
    } else {
      if (!divided) {
        subdivide();
      }
      if (northeast.insert(b) || northwest.insert(b) || southeast.insert(b) || southwest.insert(b)) {
        return true;
      }
    }
    return false;
  }

  boolean contains(Ball b) {
    return (b.sx >= position.x - width && b.sx < position.x + width &&
            b.sy >= position.y - height && b.sy < position.y + height);
  }

  ArrayList<Ball> query(PVector rangePos, float rangeW, float rangeH) {
    ArrayList<Ball> found = new ArrayList<Ball>();

    if (!intersects(rangePos, rangeW, rangeH)) {
      return found;
    }

    for (Ball b : balls) {
      if (b.sx >= rangePos.x - rangeW && b.sx < rangePos.x + rangeW &&
          b.sy >= rangePos.y - rangeH && b.sy < rangePos.y + rangeH) {
            b.ballColor = color(255,255,255);
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
    return !(rangePos.x - rangeW > position.x + width || rangePos.x + rangeW < position.x - width ||
             rangePos.y - rangeH > position.y + height || rangePos.y + rangeH < position.y - height);
  }

  void show() {
    stroke(#00FF00);
    print("shoulddraw");
    noFill();
    print(width,height);
    rect(position.x, position.y, width, height);
    if (divided) {
      northeast.show();
      northwest.show();
      southeast.show();
      southwest.show();
    }
  }
}
