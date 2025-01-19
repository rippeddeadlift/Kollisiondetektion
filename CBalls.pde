
/**
 * Container class for a number (totalball) of Ball objects
 */
public class CBalls {
  boolean impulsMasse = false;
  boolean mousedown   = false;
  Quadtree qtree;

  Ball[] ball;

  CBalls(int totalball) {
    qtree = new Quadtree(width / 2, height / 2, width / 2, height / 2, 4);
    ball = new Ball[totalball];
    for (int bn=0; bn < ball.length; bn++) {
       ball[bn] = new Ball(bn);
       qtree.insert(ball[bn]);
    }
  }

  void restart() {
  for (int bn = 0; bn < ball.length; bn++) {
  ball[bn].sx = 100;
  ball[bn].sy = 50;
  ball[bn].radius=0.4f*65;
  ball[bn].MASS = 1;
  ball[bn].vy=random(50);  
  ball[bn].vx=random(50);  
  }
}

  void draw() 
  {
    // draw the balls
    for (int bn=0; bn < ball.length; bn++) {
      ball[bn].draw();
    }
  } 

void game_physics() {
  for (int bn = 0; bn < ball.length; bn++) {
    ball[bn].game_physics();
  }


}


  void detectCollisions() {
    //log(n^2) Algorithmus (BF)
    bruteforce();
    //log(nlog(n) Algorithmus (QuadTree))
    //quadTreeDetection();
  }

 
  /* Clicked mouse */
  void Mouse() {
    if (impulsMasse){
    System.out.printf("State: MOUSE_DOWN\n");

    for (int bn = 0; bn < ball.length; bn++) {
      if (isMouseOverBall(ball[bn], mouseX, mouseY)) {
         println("Ball pressed");

        if (mouseButton == LEFT) {
          ball[bn].radius *= 1.05;
          ball[bn].MASS *= 1.1;
        } else if (mouseButton == RIGHT) {
          ball[bn].radius /= 1.05;
          ball[bn].MASS /= 1.1;
        }

        ball[bn].radius = constrain((float) ball[bn].radius, 0.4f*65, 0.4f*300);
        ball[bn].MASS = constrain((float) ball[bn].MASS, 1, 10);
    }
  }
}}
  

boolean isMouseOverBall(Ball b, float mx, float my) {
  float dx = b.Sx() - mx;
  float dy = b.Sy() - my;
  return sqrt(dx * dx + dy * dy) <= b.radius;
}


  
  void quadTreeDetection(){
    for(int i = 0; i < ball.length; i++){
      Ball b1 = ball[i];
      b1.ballColor = color(0,0,255);
      ArrayList<Ball> otherBalls = qtree.query(new PVector(ball[i].Sx(), ball[i].Sy()), ball[i].Radius() * 2, ball[i].Radius() * 2);
      for(Ball b : otherBalls){
        b.ballColor = color(255,0,0);
      }
      for(int j = 0; j < otherBalls.size(); j++){
        Ball b2 = otherBalls.get(j);
        b2.ballColor = color(0,255,0);
        float dx = (b1.Sx() - b2.Sx());
        float dy = (b1.Sy() - b2.Sy());
        float distance =  dist(ball[i].Sx(), ball[i].Sy(), otherBalls.get(j).Sx(), otherBalls.get(j).Sy());
        if(b1 != b2 && distance < (ball[i].Radius() + otherBalls.get(j).Radius())){
          collisionanswer(distance, ball[i], otherBalls.get(j), dx, dy);
        }
      }
    }
  }
  
  /* Released mouse */
  void MouseUp ()
  {
    // System.out.printf("State: MOUSE_RELEASED\n");
    // for (int bn=0; bn < ball.length; bn++) { 
    //   ball[bn].MouseUp();
    // }
  }
    void bruteforce(){
    for (int i = 0; i < ball.length; i++) {
        for (int j = i + 1; j < ball.length; j++) {
          Ball b1 = ball[i];
          Ball b2 = ball[j];
          // Formel um Distanz zu berechnen: sqrt((b2.sx-b1.sx)^2 + (b2.sy-b1.sy)^2)
          float dx = (float)(b1.sx - b2.sx);
          float dy = (float)(b1.sy - b2.sy);
          float distance = (float)Math.sqrt(dx * dx + dy * dy);  
          if (distance < b1.Radius() + b2.Radius()) {
            collisionanswer(distance, b1, b2, dx, dy);
          }
        }
    }
  }
  
  void collisionanswer(float distance, Ball b1, Ball b2, float dx, float dy){
    // dist = 100
    // b1.r + b2.r = 50
    float overlap = 0.5f * (distance - b1.Radius() - b2.Radius());
    float nx = dx / distance;
    float ny = dy / distance;
    if (overlap < 0){
      println("Overlap detected", overlap);
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
}
