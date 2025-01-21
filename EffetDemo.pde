public class EffetDemo implements DemoInterface {
  PVector wind;
  PShape basket;
  Ball ball;
  CBalls ballContainer;
  InputWindow inputWindow;
  
  PVector velocity;
  PVector position;
  PVector basketPosition = new PVector(500, 450);
  int basketWidth = 100;
  int basketHeight = 150;
  boolean paused = false; 

  PVector circlePosition;
  float circleRadius;

  void init(CBalls balls) {
    this.ballContainer = balls;
    position = new PVector(0, height/2);
    velocity = new PVector(10, 0);
    ball = balls.balls.get(0);
    ball.sx = position.x;
    ball.sy = position.y;
    ball.vx = velocity.x;
    ball.vy = velocity.y;
    ball.g_acc = 0;
    ball.spinFactor = 0f;
    ball.updateSphere();
    inputWindow = new InputWindow(this);
    PApplet.runSketch(new String[]{"Spinfaktor anpassen"}, inputWindow);
    generateCircle();
  }
  
  void display() {
    if (!paused) {
      wind = new PVector(-0.002, 0);
      PVector magnusForce = new PVector(-velocity.y, velocity.x).mult(ball.spinFactor);
      velocity.add(magnusForce);
      velocity.add(wind);
      position.add(velocity);
    
      float angularVelocityX = velocity.x / ball.radius * ball.spinFactor * 100; //*100 um die drehung stärker zu demonstrieren
      float angularVelocityY = velocity.y / ball.radius * ball.spinFactor * 100; 
      
      ball.angleX += angularVelocityX;
      ball.angleY += angularVelocityY;
      
      ball.sx = position.x;
      ball.sy = position.y;
      
      noFill();
      stroke(255);
      ellipse(circlePosition.x, circlePosition.y, circleRadius * 2, circleRadius * 2);
      
      if (isBallInsideCircle()) {
        paused = true; 
      }
      if (ball.sx < 0 || ball.sx > width || ball.sy < 0 || ball.sy > height) {
        resetBall();
        inputWindow.openWindow();
        paused = true; 
      }
    }
  }
  void close() {
    ballContainer.remove(ball);
  }

  void resetBall() {
    position = new PVector(0, height/2);
    velocity = new PVector(10, 0);
    ball.sx = position.x;
    ball.sy = position.y;
    ball.vx = velocity.x;
    ball.vy = velocity.y;
  }

  void updateSpinFactor(float newSpinFactor) {
    ball.spinFactor = newSpinFactor/100;
    paused = false; 
  }

  void generateCircle() {
    circlePosition = new PVector(random(350,700), random(100,600));
    circleRadius = ball.radius + 20;
  }

  boolean isBallInsideCircle() {
    float distance = dist(ball.Sx(), ball.Sy(), circlePosition.x, circlePosition.y);
    return distance + ball.radius < circleRadius;
  }
}
