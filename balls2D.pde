/**
 * Basic version of balls-project 
 *   (no collision, no textures)
 */
import ddf.minim.*;    // AudioPlayer, Minim
CBalls theBalls;
VectorDrawer vd;
int totalball = 10;               // number of balls 
PFont mono;
Effet effet;
boolean showHelp=false;          // toggle help text
boolean forceFreeze = false;     // toggle game physics 
boolean frictionMode=false;      // may be used in class Ball
boolean randomFloor = true;      // may be used in class Ball
boolean showModes = true;
boolean drawVector = false;
boolean makeEffet = false;

//modes
boolean noCollision = true;
boolean collision = false;
boolean impulsMasse = false;
TunnelingDemo tunnelingDemo = new TunnelingDemo();
Mode currentMode = Mode.NOCOLLISION;
PGraphics pg;


color c_red = color(255,0,0);
float leftwall_x  = 0;
float ceiling_y   = 0;
float rightwall_x;
float floor_y;
float mid_x;

Minim minim; 

void setup() 
{
  size(700, 700, P3D);            
  theBalls = new CBalls(totalball);
  vd = new VectorDrawer();
  effet = new Effet(theBalls);
  rightwall_x = width;
  floor_y     = height;
  mid_x = width/2.0;

  mono = createFont("Cascadia Code", 22);
  frameRate(50);
  pg = createGraphics(width, height);
  pg.beginDraw();
  pg.textFont(mono);
  pg.fill(255, 255, 255);
  pg.text("1: Root Mode / Normalmode ", 10, 35);
  pg.text("2: Kollisiondetektion", 10, 35 + 1 * 25);
  pg.text("3: Impuls / Masse", 10, 35 + 2 * 25);
  pg.text("4: Tunneling Demonstration", 10, 35 + 3 * 25);
  pg.text("e: Effet ",400,35);
  pg.text("v: VectorDrawer",400,35+1*25);
  pg.endDraw();

}

void draw() 
{
    background(80);  // gray background 
    if(impulsMasse){
      textFont(mono);
      fill(255, 255, 255);
      text("Ball linksclick: +10% Masse, +5% Radius", 10, 600 + 2 * 25);
      text("Ball Rechtsclick: -10% Masse, -5% Radius", 10, 600 + 3 * 25);
    }
    if(showModes) background(pg);
    if (noCollision) {
      startDrawingBallsAndPhysics();
  } else if (collision) {
      startDrawingBallsAndPhysics();
        if (!forceFreeze)  
          theBalls.detectCollisions();
  } else if (impulsMasse) {
        startDrawingBallsAndPhysics();
        if (!forceFreeze)  
          theBalls.detectCollisions();
        theBalls.impulsMasse = true;
  }
}
void startDrawingBallsAndPhysics() {
  lightSpecular(255,255,255);
  directionalLight(204, 204, 204, 0, +1, -1);
  translate(0,0,-2);    // optional, just to show the box border
  boxDraw();
  theBalls.draw();
  if (!forceFreeze)  
    theBalls.game_physics();
  if(drawVector){
    vd = new VectorDrawer();
    vd.draw(theBalls);
  }
  if(makeEffet){
    effet = new Effet(theBalls);
    effet.draw();
  }
  if(currentMode == Mode.TUNNELING){
    tunnelingDemo.draw();
  }
}


// draw the sphere-confing box
void boxDraw() {
    stroke(c_red);
    noFill();
    beginShape(QUADS);
           vertex(leftwall_x ,  floor_y);
           vertex(leftwall_x ,ceiling_y);
           vertex(rightwall_x,ceiling_y);
           vertex(rightwall_x,  floor_y);
    endShape();
} 



void keyPressed()
{
  switch(key)
  {
  case '1':
    activateMode(Mode.NOCOLLISION);
    break;
  case '2':
    activateMode(Mode.COLLISION);
    break;
  case '3':
    activateMode(Mode.IMPULSE);
    break;
  case '4':
    activateMode(Mode.TUNNELING);
    break;
  case 'v':
      drawVector = !drawVector;
      break;
  case 'e':
      makeEffet = !makeEffet;
      if (!makeEffet){
        effet.resetBallFlags();
      }
      break;
  case 't':
     if(currentMode == Mode.TUNNELING){
      println("im in tunneling mode");
       tunnelingDemo.adjustFramerateAndYVelocity();
     }
      break;
  case ESC:
    exit();
    break;
  case ' ':
    forceFreeze = !forceFreeze;
    break;
  case 'h':
    showModes = !showModes;
    break;
  case 'r':
    randomFloor = !randomFloor; 
    if ( randomFloor) println("State: random floor ON"); 
    if (!randomFloor) println("State: random floor OFF"); 
    break;
  case 'f':
    frictionMode = !frictionMode;
    if ( frictionMode) println("State: friction Mode ON"); 
    if (!frictionMode) println("State: friction Mode OFF"); 
    break;
  }
}

void restart() {
theBalls.restart();
}


void activateMode(Mode mode) {
  

  noCollision = false;
  collision = false;
  impulsMasse = false;
  theBalls.impulsMasse = false;
  if (mode != mode.TUNNELING) {
    restart();
    showModes = true;
    tunnelingDemo.close();
  }
  switch(mode){
    case NOCOLLISION:
      noCollision = true;
      currentMode = Mode.NOCOLLISION;
      break;
    case COLLISION:
      collision = true;
      currentMode = Mode.COLLISION;
      break;
    case IMPULSE:
      impulsMasse = true;
      currentMode = Mode.IMPULSE;
      break;
    case TUNNELING:
      collision = true;

      for (int i = 1; i < theBalls.ball.length; i++) {
        Ball ball = theBalls.ball[i];
        
        ball.active = false; 
      }

      //CBalls theBallss = new CBalls(1);
      currentMode = Mode.TUNNELING;
      tunnelingDemo.init(theBalls);
      break;
 
}}


void mousePressed(){
  theBalls.Mouse();
}

void mouseReleased(){
  theBalls.MouseUp();
}
