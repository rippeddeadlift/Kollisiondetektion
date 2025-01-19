/**
 * Basic version of balls-project 
 *   (no collision, no textures)
 */
import ddf.minim.*;    // AudioPlayer, Minim
CBalls theBalls;
VectorDrawer vd;
int totalball = 2;               // number of balls 
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
TunnelingDemo tunnelingDemo = new TunnelingDemo();
Mode currentMode = Mode.NOCOLLISION;
PGraphics pg; 

color c_red = color(255,0,0);
float leftwall_x  = 0;
float ceiling_y   = 0;
float rightwall_x;
float floor_y;
float mid_x;

void setup() 
{
  size(700, 700, P3D);
  frameRate(50);
  theBalls = new CBalls(totalball);
  vd = new VectorDrawer();
  effet = new Effet(theBalls);
  rightwall_x = width;
  floor_y     = height;
  mid_x = width/2.0;
  mono = createFont("Cascadia Code", 22);
  pg = createGraphics(width, height);
  pg.beginDraw();
  pg.textFont(mono);
  pg.fill(255, 255, 255);
  pg.text("1: Root Mode / Normalmode ", 10, 35);
  pg.text("2: Kollisiondetektion", 10, 35 + 1 * 25);
  pg.text("3: Impuls Demonstration", 10, 35 + 2 * 25);
  pg.text("4: Tunneling Demonstration", 10, 35 + 3 * 25);
  pg.text("e: Effet ",400,35);
  pg.text("v: VectorDrawer",400,35+1*25);
  pg.endDraw();

}
void draw() 
{
    background(80);  // gray background 
    if(showModes) background(pg);
    startDrawingBallsAndPhysics();
    switch(currentMode){
      case TUNNELING:
        tunnelingDemo.draw();
        break;
      case NOCOLLISION:
        break;
      case COLLISION:
        if(!forceFreeze) theBalls.detectCollisions();
        break;
      case IMPULSE:
        if(!forceFreeze) theBalls.detectCollisions();
        theBalls.impulsMasse = true;
        textFont(mono);
        fill(255, 255, 255);
        text("Ball linksclick: +10% Masse, +5% Radius", 10, 600 + 2 * 25);
        text("Ball Rechtsclick: -10% Masse, -5% Radius", 10, 600 + 3 * 25);
        break;  
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
}

void setupLighting() {
    lightSpecular(255, 255, 255);
    directionalLight(204, 204, 204, 0, +1, -1);
}

void drawScene() {
    translate(0, 0, -2); // Optional, just to show the box border
    boxDraw();
    theBalls.draw();
}

void handlePhysics() {
    if (!forceFreeze) {
        theBalls.game_physics();
    }
}

void handleOptionalEffects() {
    if (drawVector) {
        VectorDrawer vd = new VectorDrawer();
        vd.draw(theBalls);
    }
    if (makeEffet && !forceFreeze) {
        Effet effet = new Effet(theBalls);
        effet.draw();
    }
    if (currentMode == Mode.TUNNELING) {
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
  case 'q':
    addBall();
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

void activateMode(Mode mode) {
  theBalls.impulsMasse = false;
  switch(mode){
    case NOCOLLISION:
      currentMode = Mode.NOCOLLISION;
      break;
    case COLLISION:
      currentMode = Mode.COLLISION;
      break;
    case IMPULSE:
      currentMode = Mode.IMPULSE;
      break;
    case TUNNELING:
      currentMode = Mode.TUNNELING;
      theBalls = new CBalls(1);
      tunnelingDemo.init(theBalls);
      break;
}}

void toggleAlgorithm(){
  theBalls.useQuadTree = !theBalls.useQuadTree;
}

void addBall(){
  if(currentMode != Mode.TUNNELING){
    Ball ball = new Ball(0, true);
    theBalls.add(ball);
  }
}

void mousePressed(){
  theBalls.Mouse();
}

void mouseReleased(){
  theBalls.MouseUp();
}
