/**
 * Basic version of balls-project 
 * 	(no collision, no textures)
 */
import ddf.minim.*;    // AudioPlayer, Minim

CBalls theBalls;
VectorDrawer vd;
int totalball = 10;               // number of balls 
PFont mono;
boolean showHelp=false;          // toggle help text
boolean forceFreeze = false;     // toggle game physics 
boolean frictionMode=false;      // may be used in class Ball
boolean randomFloor = true;      // may be used in class Ball
boolean showModes = true;
boolean drawVector = false;

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
  helpFont = createFont("Arial", 22, true);
  rightwall_x = width;
  floor_y     = height;
  mid_x = width/2.0;

  frameRate(50);
  pg = createGraphics(width, height);
  pg.beginDraw();
  PFont mono = createFont("Cascadia Code", 22);
  pg.textFont(mono);
  pg.fill(255, 255, 255);
  pg.text("1: Root Mode / Normalmode ", 100, 35);
  pg.text("2: Kollisiondetektion", 100, 35 + 1 * 25);
  pg.text("3: Impuls / Masse", 100, 35 + 2 * 25);
  pg.text("4: Tunneling Demonstration", 100, 35 + 3 * 25);
  pg.endDraw();

}

void draw() 
{
    background(80);  // gray background 
    if(showModes) image(pg, 0, 0);
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
    vd.draw(theBalls);
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
  restart();

  noCollision = false;
  collision = false;
  impulsMasse = false;
  theBalls.impulsMasse = false;
  switch(mode){
    case NOCOLLISION:
      noCollision = true;
      theBalls = new CBalls(totalball);
      tunnelingDemo.close();
      break;
    case COLLISION:
      collision = true;
      theBalls = new CBalls(totalball);
      tunnelingDemo.close();
      break;
    case IMPULSE:
      impulsMasse = true;
      theBalls = new CBalls(totalball);
      tunnelingDemo.close();
      break;
    case TUNNELING:
      showModes = false;
      collision = true;
      theBalls = new CBalls(1);
      tunnelingDemo.init(theBalls);
      currentMode = Mode.TUNNELING;
      break;
 
}}


void mousePressed(){
  theBalls.Mouse();
}

void mouseReleased(){
  theBalls.MouseUp();
}
