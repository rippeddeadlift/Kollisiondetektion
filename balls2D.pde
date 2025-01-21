CBalls theBalls;
VectorDrawer vd;
TextDrawer td;
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
TunnelingDemo tunnelingDemo = new TunnelingDemo();
EffetDemo effetDemo = new EffetDemo();
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
  td = new TextDrawer();
  rightwall_x = width;
  floor_y     = height;
  mid_x = width/2.0;
  pg = td.setupMenuText();
}
void draw() 
{
    background(80);  // gray background 
    if(showModes) background(pg);
    td.displayCurrentFps();
    td.displayAmountOfElements(theBalls.balls.size());
    startDrawingBallsAndPhysics();
    switch(currentMode){
      case TUNNELING:
        tunnelingDemo.display();
        break;
      case NOCOLLISION:
        break;
      case COLLISION:
        theBalls.detectCollisions();
        break;
      case IMPULSE:
        theBalls.displayAlgorithmicChecks = false;
        if(!forceFreeze) theBalls.detectCollisions();
        theBalls.impulsMasse = true;
        td.displayImpulseHintText();
        break;  
      case EFFET:
       effetDemo.display();
       break;
    }
}
void startDrawingBallsAndPhysics() {
  lightSpecular(255,255,255); 
  directionalLight(204, 204, 204, 0, +1, -1);
  translate(0,0,-2);    // optional, just to show the box border
  boxDraw();
  theBalls.draw();
  if (!forceFreeze )  
    theBalls.game_physics();
  if(drawVector){
    vd = new VectorDrawer();
    vd.draw(theBalls);
  }
  if(makeEffet&& !forceFreeze){
    effet = new Effet(theBalls);
    effet.draw();
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
  case '5':
    activateMode(Mode.EFFET);
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
  case 'x':
   toggleAlgorithm();
   break;
  case 'y':
    toggleDisplayConnections();
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
  theBalls.bruteForceChecks = 0;
  theBalls.quadTreeChecks = 0;
  theBalls = new CBalls(totalball);
  switch(mode){
    case NOCOLLISION:
      currentMode = Mode.NOCOLLISION;
      theBalls.displayAlgorithmicChecks = false;
      break;
    case COLLISION:
      theBalls.displayAlgorithmicChecks = true;
      currentMode = Mode.COLLISION;
      break;
    case IMPULSE:
      currentMode = Mode.IMPULSE;
      theBalls.displayAlgorithmicChecks = false;
      break;
    case TUNNELING:
      currentMode = Mode.TUNNELING;
      theBalls.displayAlgorithmicChecks = false;
      theBalls = new CBalls(1);
      tunnelingDemo.init(theBalls);
      break;
    case EFFET:
      currentMode = Mode.EFFET;
      theBalls.displayAlgorithmicChecks = false;
      theBalls = new CBalls(1);
      effetDemo.init(theBalls);
      break;
      }
    frameRate(50);
  }

void toggleAlgorithm(){
  theBalls.useQuadTree = !theBalls.useQuadTree;
}
void toggleDisplayConnections(){
  theBalls.displayConnections = !theBalls.displayConnections;
}

void addBall(){
  if(currentMode != Mode.TUNNELING && currentMode != Mode.IMPULSE && currentMode != Mode.EFFET){
    Ball ball = new Ball(0, true);
    theBalls.add(ball);
    totalball++;
  }
}
void removeBall(){
  if(currentMode != Mode.TUNNELING && currentMode != Mode.IMPULSE && currentMode != Mode.EFFET){
    if (!theBalls.isEmpty()) {
      for(Ball ball : theBalls.balls){
        if(theBalls.isMouseOverBall(ball, mouseX, mouseY)){
          if (mouseButton == RIGHT) {
            theBalls.remove(ball);  
            totalball--;
            break; 
          }
        }
      }
    }
  }
}



void mousePressed(){
   if (mouseButton == LEFT) { 
      addBall();
    } else if (mouseButton == RIGHT) {
      removeBall();
    }


  theBalls.Mouse();
}

void mouseReleased(){
  theBalls.MouseUp();
}
