/**
 * Basic version of balls-project 
 * 	(no collision, no textures)
 */
import ddf.minim.*;    // AudioPlayer, Minim

CBalls theBalls;
int totalball = 10;               // number of balls 
PFont helpFont;      
boolean showHelp=false;          // toggle help text
boolean forceFreeze = false;     // toggle game physics 
boolean frictionMode=false;      // may be used in class Ball
boolean randomFloor = true;      // may be used in class Ball
boolean showModes = true;
boolean isRestarting = false;

//modes
boolean noCollision = true;
boolean collision = false;
boolean impulsMasse = false;


color c_red = color(255,0,0);
float leftwall_x  = 0;
float ceiling_y   = 0;
float rightwall_x;
float floor_y;
float mid_x;

Minim minim; 

void setup() 
{
  size(700, 700, P3D);           // although the game physics is 2D, we do the drawing in 3D to allow 
                                 // for 3D-balls (spheres) with directional light and shininess
                                 
  theBalls = new CBalls(this,totalball);
  helpFont = createFont("Arial", 22, true);
  rightwall_x = width;
  floor_y     = height;
  mid_x = width/2.0;

}
void draw() 
{
  // if (showHelp) {
  //   textFont(helpFont);
  //   fill(255,255,255);
  //   text("h: toggle help",100,35);
  //   text("r: toggle random floor",100,35+1*25);
  //   text("<SPACE>: freeze",100,35+2*25);
  //   text("<ESC>: exit",100,35+3*25);
  // } 
    background(80);  // gray background 

  if (showModes) {
    PFont mono;
    mono = createFont("Cascadia Code", 22);
    textFont(mono);
    fill(255,255,255);
    text("1: Root Mode / Normalmode ",100,35);
    text("2: Kollisiondetektion",100,35+1*25);
    text("3: Impuls / Masse",100,35+2*25);
    text("4: bla",100,35+3*25);
     if(impulsMasse){
    text("Ball Linksclick: Radius + 5%, Masse + 10% ",100,35+25*25);
    text("Ball Rechtsclick: Radius - 5%, Masse - 10% ",100,35+26*25);

    }

  }
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

    // ---- activate this code snippet for exercise U5 ------
    
    // beginShape(LINES);
    //   vertex(mid_x ,  floor_y);
    //   vertex(mid_x ,ceiling_y);
    // endShape();
               
    // ------------------------------------------------------
} // boxDraw()

void stop()
{
  theBalls.stop();
}

void keyPressed()
{
  switch(key)
  {
  case '1':
    activateMode("noCollision");
    break;
  case '2':
    activateMode("collision");
    break;
  case '3':
    activateMode("impulsMasse");
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


void activateMode(String mode) {
 if (isRestarting) {
    return; 
  }
isRestarting = true; 
      restart();
  noCollision = false;
  collision = false;
  impulsMasse = false;
  theBalls.impulsMasse = false;

  if (mode.equals("noCollision")) {
    noCollision = true;
  } else if (mode.equals("collision")) {
    collision = true;
  } else if (mode.equals("impulsMasse")) {
    impulsMasse = true;
  }
  isRestarting = false;
}
void mousePressed(){
  theBalls.Mouse();
}

void mouseReleased(){
  theBalls.MouseUp();
}