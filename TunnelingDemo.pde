public class TunnelingDemo{
  TextDrawer td;
  CBalls ballContainer;
  Ball ball;
  boolean collisionDetected = false;
  boolean active = false;
  int counter = 0;
  PGraphics pg;
  
  public void init(CBalls ballContainer){
    td = new TextDrawer();
    this.active = true;
    counter = 0;
    this.ballContainer = ballContainer;
    this.ball = ballContainer.balls.get(0);
    ball.vx = 0;
    ball.sx = width/2;
    ball.sy = 0;
    frameRate(50);
    draw();
  }
  void draw(){
    if(active){
      
    showHint();
      if(collisionDetected){
        fill(0,255,0);
      }else{
        fill(255, 255, 0);
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
      pg = td.setupTunnelingDemoHintText(counter % 2 == 0);
      image(pg,0,0);
  }
  
  void adjustFramerateAndYVelocity(){
      ball.vx = 0;
      ball.sx = width/2;
      ball.sy = 0;
    if(counter % 2 == 0){
      ball.vy = 2500;
      frameRate(3);
    }else{
      ball.vy = 25;
      frameRate(120);
    }
    counter++;
  }
}
