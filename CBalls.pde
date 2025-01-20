/**
 * Container class for a number (totalball) of Ball objects
 */
public class CBalls {
  boolean impulsMasse = false;
  boolean mousedown   = false;
  Quadtree qtree;
  int bruteForceChecks = 0;
  int quadTreeChecks = 0;
  ConnectionDrawer cd;
  boolean useQuadTree = false;

  ArrayList<Ball> balls = new ArrayList();

  CBalls(int totalball) {
    qtree = new Quadtree(0, 0, width, height, 4);
    for (int bn=0; bn < totalball; bn++) {
       Ball ball = new Ball(0);
       balls.add(ball);
       qtree.insert(ball);
    }
    cd = new ConnectionDrawer();
  }

  void draw() 
  {
    qtree = new Quadtree(0, 0, width, height, 4);
    for(Ball ball : balls){
      qtree.insert(ball);
      ball.draw();
    }
    if(useQuadTree) qtree.show();
    text("BF Checks: " + bruteForceChecks, 50, 600 + 2 * 25 );
    text("QT Checks: " + quadTreeChecks, 50, 600 + 3 * 25 );
  } 

void game_physics() {
  for(Ball ball : balls){
      ball.game_physics();
    }
}
  void detectCollisions() {
    //log(n^2) Algorithmus (BF)
    bruteforce();
    //log(nlog(n) Algorithmus (QuadTree))
    //quadTreeDetection();
  }

  void Mouse() {
    if (impulsMasse){
    System.out.printf("State: MOUSE_DOWN\n");

    for (Ball ball : balls) {
      if (isMouseOverBall(ball, mouseX, mouseY)) {
         println("Ball pressed");

        if (mouseButton == LEFT) {
          ball.radius *= 1.05;
          ball.MASS *= 1.1;
        } else if (mouseButton == RIGHT) {
          ball.radius /= 1.05;
          ball.MASS /= 1.1;
        }

        ball.radius = constrain((float) ball.radius, 0.4f*65, 0.4f*300);
        ball.MASS = constrain((float) ball.MASS, 1, 10);
    }
  }
}} 


 
  boolean isMouseOverBall(Ball b, float mx, float my) {
    float dx = b.Sx() - mx;
    float dy = b.Sy() - my;
    return sqrt(dx * dx + dy * dy) <= b.radius;
  }
  void bruteforce() {
      for (Ball b1 : balls) {
          for (Ball b2 : balls) {
              bruteForceChecks++;
              if(!useQuadTree)cd.draw(b1,b2);
              if (b1 != b2) {
                  // Formel um Distanz zu berechnen: sqrt((b2.sx-b1.sx)^2 + (b2.sy-b1.sy)^2)
                  float dx = (float)(b1.sx - b2.sx);
                  float dy = (float)(b1.sy - b2.sy);
                  float distance = (float)Math.sqrt(dx * dx + dy * dy);
                  if (distance <= b1.Radius() + b2.Radius() && !useQuadTree) {
                      collisionanswer(distance, b1, b2, dx, dy);
                  }
              }
          }
      }
  }
  
  void quadTreeDetection(){
    for(int i = 0; i < balls.size(); i++){
      Ball b1 = balls.get(i);
      ArrayList<Ball> otherBalls = qtree.query(new PVector(b1.Sx(), b1.Sy()), b1.Radius() * 2, b1.Radius() * 2);
      for(int j = 0; j < otherBalls.size(); j++){
        quadTreeChecks++;
        Ball b2 = otherBalls.get(j);
        if(useQuadTree) cd.draw(b1,b2);
        float dx = (b1.Sx() - b2.Sx());
        float dy = (b1.Sy() - b2.Sy());
        float distance =  dist(b1.Sx(), b1.Sy(), b2.Sx(), b2.Sy());
        if(b1 != b2 && distance < (b1.Radius() + b2.Radius()) && useQuadTree){
            collisionanswer(distance, b1, b2, dx, dy);
        }
      }
    }
  }
  
  /* Released mouse */
 
  
  void collisionanswer(float distance, Ball b1, Ball b2, float dx, float dy){
    float overlap = 0.5f * (distance - b1.Radius() - b2.Radius());
    float nx = dx / distance;
    float ny = dy / distance;
    if (overlap < 0){
      b1.sx -= overlap * (b1.sx - b2.sx) / distance;
      b1.sy -= overlap * (b1.sy - b2.sy) / distance;
      b2.sx += overlap * (b1.sx - b2.sx) / distance;
      b2.sy += overlap * (b1.sy - b2.sy) / distance;
    }
     float dvx = (float)(b1.vx - b2.vx);
     float dvy = (float)(b1.vy - b2.vy);
  

  //dot() for dot product
     float skalarprodukt = dvx * nx + dvy * ny;
  
     if (skalarprodukt <= 0){
       float impulse = 2 * skalarprodukt / (float)(b1.MASS + b2.MASS);
  
       b1.vx -= impulse * b2.MASS * nx;
       b1.vy -= impulse * b2.MASS * ny;
       b2.vx += impulse * b1.MASS * nx;
       b2.vy += impulse * b1.MASS * ny;
     };
 
  }

  
  /* Released mouse */
  void MouseUp ()
  {
    // System.out.printf("State: MOUSE_RELEASED\n");
    // for (int bn=0; bn < ball.length; bn++) { 
    //   ball[bn].MouseUp();
    // }
  }
  
  void add(Ball ball){
    balls.add(ball);
    qtree.insert(ball);
  }
  void remove(Ball ball){
    balls.remove(ball);
    //Todo remove qtree ball
    //qtree.remove(ball);
  }
  Ball get(int number){
    return balls.get(number); 
  }
  int size(){
    return balls.size();
  }
  boolean isEmpty(){
    return balls.isEmpty();
  }

}
