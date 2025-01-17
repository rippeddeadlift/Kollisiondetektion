public class TunnelingDemo{
  
  final String LOW_FPS_HINT_TEXT = "LOW FPS, HIGH VELOCITY, HARD TO DETECT, \n PRESS T TO TOGGLE NORMAL";
  final String HIGH_FPS_HINT_TEXT = "HIGH FPS, MODERATE VELOCITY, UNDETECTABLE, \n PRESS T TO TOGGLE TUNNELING";
  CBalls ballContainer;
  Ball ball;
  boolean collisionDetected = false;
  boolean active = false;
  int counter = 0;
  
  public void init(CBalls ballContainer){
    this.active = true;
    this.ballContainer = ballContainer;
    this.ball = ballContainer.ball[0];
    ball.vx = 0;
    ball.sx = width/2;
    frameRate(60);
    draw();
  }
  void draw(){
    showHint();
    if(active){
      if(collisionDetected){
        fill(255,255,0);
      }else{
        fill(0,255,0);
      }
      rect(0, height / 2,  width, 50);
      detectCollisionWithRectangle(ball, 0f, float(height/2), float(width), 50f);
    }
  }
  
  void detectCollisionWithRectangle(Ball ball,float rx, float ry, float rw, float rh){
    float closestX = constrain(ball.Sx(), rx, rx + rw);
    float closestY = constrain(ball.Sy(), ry, ry + rh);
    
    float distanceX = ball.Sx() - closestX;
    float distanceY = ball.Sy() - closestY;
    float distance = sqrt(distanceX * distanceX + distanceY * distanceY);
 
     if(distance <= ball.Radius()){
       collisionDetected = true;
       ball.vy = 0;
     }else{
       collisionDetected = false;
     };
  }
  
  void close(){
    this.active = false;
  }
  
  void showHint(){
    PFont mono;
    mono = createFont("Cascadia Code", 22);
    textFont(mono);
    fill(255,255,255);
    if(counter % 2 == 0){
      text(HIGH_FPS_HINT_TEXT, 100,35);
    }else{
      text(LOW_FPS_HINT_TEXT, 100,35);
    }
  }
  
  void adjustFramerateAndYVelocity(){
    if(counter % 2 == 0){
      ball.vx = 0;
      ball.sx = width/2;
      ball.sy = 0;
      ball.vy = 2500;
      frameRate(3);
    }else{
      ball.vx = 0;
      ball.sx = width/2;
      ball.sy = 0;
      ball.vy = 25;
      frameRate(120);
    }
    counter++;
  }
}
