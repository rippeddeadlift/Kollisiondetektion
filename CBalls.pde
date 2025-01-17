
/**
 * Container class for a number (totalball) of Ball objects
 */
public class CBalls {
  boolean impulsMasse = false;
  boolean mousedown   = false;

  Ball[] ball;

  CBalls(PApplet pApp, int totalball) {
    minim = new Minim(pApp);

    ball = new Ball[totalball];
    for (int bn=0; bn < ball.length; bn++) 
      ball[bn] = new Ball(minim, bn);
  }

  //if mode == Mass
  // CBalls(PApplet pApp, int totalball, float radius) {
  //   minim = new Minim(pApp);

  //   ball = new Ball[totalball];
  //   for (int bn=0; bn < ball.length; bn++) 
  //     ball[bn] = new Ball(minim, bn, radius);
  // }

  void draw() 
  {
    // draw the balls
    for (int bn=0; bn < ball.length; bn++) 
      ball[bn].draw();
  } 

 void game_physics() {
    for (int bn = 0; bn < ball.length; bn++) {
      ball[bn].game_physics();
    }
  }

  void detectCollisions() {
    for (int i = 0; i < ball.length; i++) {
      for (int j = i + 1; j < ball.length; j++) {
        Ball b1 = ball[i];
        Ball b2 = ball[j];

        // Distanz zwischen den Bällen
        // die Differenz der x & y -Koordinaten          
        // Formel um Distanz zu berechnen: sqrt((b2.sx-b1.sx)^2 + (b2.sy-b1.sy)^2)

        float dx = (float)(b1.sx - b2.sx);
        float dy = (float)(b1.sy - b2.sy);
        float distance = (float)Math.sqrt(dx * dx + dy * dy);  


        if (distance < b1.Radius() + b2.Radius()) {



          float overlap = 0.5f * (distance - b1.Radius() - b2.Radius());

          // Einheitsvektor, zeigt die Richtung des Vektors an
          float nx = dx / distance;
          float ny = dy / distance;


          if (overlap >0){
            println("Overlap detected", overlap);
          b1.sx -= overlap * (b1.sx - b2.sx) / distance;
          b1.sy -= overlap * (b1.sy - b2.sy) / distance;
          b2.sx += overlap * (b1.sx - b2.sx) / distance;
          b2.sy += overlap * (b1.sy - b2.sy) / distance;
          }

    //           double overlap = (ball1.radius + ball2.radius) - distance;
    // if (overlap > 0) {
    //     // Korrektur der Positionen proportional zur Masse
    //     double correctionFactor = overlap / 2;
    //     ball1.sx -= nx * correctionFactor;
    //     ball1.sy -= ny * correctionFactor;
    //     ball2.sx += nx * correctionFactor;
    //     ball2.sy += ny * correctionFactor;
    // }
  



          // Relative Geschwindigkeit
          float dvx = (float)(b1.vx - b2.vx);
          float dvy = (float)(b1.vy - b2.vy);

          // Skalarprodukt zweier Vektoren 
          float skalarprodukt = dvx * nx + dvy * ny;

          if (skalarprodukt > 0) continue;

          // Calculate the impulse scalar
          float impulse = 2 * skalarprodukt / (float)(b1.MASS + b2.MASS);

          // Apply the impulse to each ball's velocity
          b1.vx -= impulse * b2.MASS * nx;
          b1.vy -= impulse * b2.MASS * ny;
          b2.vx += impulse * b1.MASS * nx;
          b2.vy += impulse * b1.MASS * ny;

          // b1.ballColor = color(random(255),random(255),random(255));
          // b2.ballColor = color(random(255),random(255),random(255));




        }
      }
    }
  }

  void stop()
  {
    // make sure to close all AudioPlayer objects
    for (int bn=0; bn < ball.length; bn++) { 
      ball[bn].kick.close(); 
      ball[bn].snare.close();
    }  

    minim.stop();
  }


  /* Clicked mouse */
  void Mouse() {
    if (impulsMasse){
    System.out.printf("State: MOUSE_DOWN\n");

    for (int bn = 0; bn < ball.length; bn++) {
      if (isMouseOverBall(ball[bn], mouseX, mouseY)) {
         println("Ball pressed");

        if (mouseButton == LEFT) {
          ball[bn].radius *= 1.049;
          ball[bn].MASS *= 1.1;
        } else if (mouseButton == RIGHT) {
          ball[bn].radius /= 1.1;
          ball[bn].MASS /= 1.1;
        }

        ball[bn].radius = constrain((float) ball[bn].radius, 0.4f*75, 0.4f*300);
        ball[bn].MASS = constrain((float) ball[bn].MASS, 1, 10);
    }
  }
}}
  

boolean isMouseOverBall(Ball b, float mx, float my) {
  float dx = b.Sx() - mx;
  float dy = b.Sy() - my;
  return sqrt(dx * dx + dy * dy) <= b.radius;
}



  /* Released mouse */
  void MouseUp ()
  {
    // System.out.printf("State: MOUSE_RELEASED\n");
    // for (int bn=0; bn < ball.length; bn++) { 
    //   ball[bn].MouseUp();
    // }
  }
}
