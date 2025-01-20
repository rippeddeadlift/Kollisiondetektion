class Quadtree {
  int capacity;
  ArrayList<Ball> balls;
  boolean divided;
  PVector position;
  float width_, height_;
  Quadtree[] children;
  PShape square;
  boolean showGrid = false;

  Quadtree(float x, float y, float w, float h, int n) {
    position = new PVector(x, y);
    width_ = w;
    height_ = h;
    capacity = n;
    balls = new ArrayList<Ball>();
    divided = false;
    this.children = new Quadtree[4];
  }

  void subdivide() { //<>//
    float x = position.x;
    float y = position.y;
    float w = width_ / 2;
    float h = height_ / 2;
    children[0] = new Quadtree(x + w, y, w, h, capacity);
    children[1] = new Quadtree(x, y, w, h, capacity);
    children[2] = new Quadtree(x, y + h, w, h, capacity);
    children[3] = new Quadtree(x + w, y + h, w, h, capacity);
    
    divided = true;
  }
  
  void clear(){
    this.balls.clear();
    for(int i = 0; i < children.length; i++ ){
      if(children[i] != null){
        children[i].clear();
        children[i] = null;
      }
    }
  }
  
  private int getIndex(Ball b) {
  int index = -1;
  float verticalMid = position.x + this.width_ / 2;
  float horizontalMid = position.y + this.height_ / 2;
  boolean topQuadrant = b.Sy() < horizontalMid && b.Sy() + b.Radius() * 2 < horizontalMid;
  boolean bottomQuadrant = b.Sy() >= horizontalMid;

  if (b.Sx() < verticalMid && b.Sx() + b.Radius() * 2 < verticalMid) {
    if (topQuadrant) {
      index = 1; // in northwest tree
    } else if (bottomQuadrant) {
      index = 2; // in southwest tree
    }
  } else if (b.Sx() >= verticalMid) {
    if (topQuadrant) {
      index = 0; // in northeast tree
    } else if (bottomQuadrant) {
      index = 3; // in southeast tree
    }
  }
  return index;
}
  
  public void insert(Ball b){
    if(children[0] != null){
      int index = getIndex(b);
      if(index != -1){
        children[index].insert(b);
        return;
      }
    }
      balls.add(b);
      if(balls.size() > capacity){
        if(children[0] == null){
          subdivide();
          divided = true;
        }
        int i = 0;
        while(i < balls.size()){
          int index = getIndex(balls.get(i));
          if(index != -1){
            children[index].insert(balls.remove(i));
          }else{
            i++;
          }
        }        
      }
  }
  
  public ArrayList<Ball> retrieve(ArrayList<Ball> returnObjects, Ball b){
    int index = getIndex(b);
    if(index != -1 && children[0] != null){
      children[index].retrieve(returnObjects, b);
    }
    returnObjects.addAll(balls);
    return returnObjects;
  }  //<>//


  void show() {
      stroke(color(255,255,0));
      noFill();
      rect(position.x, position.y, width_, height_);
      if (divided) {
        children[0].show();
        children[1].show();
        children[2].show();
        children[3].show();
      }
    }
}
