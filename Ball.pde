/**
 * Class for a single ball, contains game physics, boundary reflections
 * and audio effects:
 *    (i)   a 'kick' sound when hitting the floor
 *    (ii)  a 'snare' sound when hitting one of the other three walls
 */
public class Ball
{
  double DT = 0.06;	// time increment
  double MASS = 1.0;
  double g_acc = +9.8;	// gravity constant
  color ballColor = color(255,0,0);
  double times;		// time since start
  double sx, sy;		// actual position 
  double vx, vy;		// actual velocity 
  double ax, ay;		// acceleration, currently constant = (0,+9.8)
  double radius;
  int bn;  
  float angleX = 0; 
  float angleY = 0;
  boolean makeEffet = false;
         

  boolean mousedown   = false;

  Ball (int count) {
    this.radius=0.4f*60;
    this.bn=count;
    // we initialize with increasingly more negative 'times' 
    // >> the balls pop up one after another:
    this.times=-10*DT*count;
    this.vy=random(50);  
    this.sy=+50;      
    this.vx=random(50);  
    this.sx=100;
  }

 void draw() {
  if (times >= 0) {
    pushMatrix();
    translate(Sx(), Sy(), 0); 
    rotateX(angleX);     
    rotateY(angleY);      

    fill(ballColor);
    noStroke();
    specular(ballColor);
    shininess(5.0);
    sphere(this.Radius());  
    if(makeEffet){
      drawEffet();
    }
    popMatrix();
  }
}
  void drawEffet(){
    float px = (float)radius /3 ; 
    float py = 0;             
    float pz =0; 
      
    pushMatrix();
    translate(px, py, pz); 
    fill(0, 255, 0); 
    noStroke();
    sphere((float)radius * 0.71); 
    popMatrix();
  }


  void game_physics()
  {
    double dx, dy;
    this.times+=DT;

    accumulateForces();              

    dx = this.vx * DT;
    dy = this.vy * DT; 
    this.vx += this.ax * DT;
    this.vy += this.ay * DT;

    applyBoundaryReflections(dx, dy); // modifies this.sx, .sy, .vx, .vy

    /*
     println("sx,sy = "+ this.sx+", "+this.sy);                  
     println("ax,ay = "+ this.ax+", "+this.ay);                  
     println("vx,vy = "+ this.vx+", "+this.vy);                  
     println("dx,dy = "+ dx+", "+dy);                  
     */
  }

  void accumulateForces() {
    double Fx = 0;
    double Fy = MASS*g_acc;

    this.ax = Fx/MASS;
    this.ay = Fy/MASS;
  }

  /*
   * applyBoundaryReflections: check whether the suggested space step (dx,dy)  
   * for this ball would bring it outside the confining box. If so, then
   * change (dx,dy) to go not further than the box wall AND reflect the 
   * velocity (vx,vy) of the ball. For ceiling, left and rigth wall the 
   * reflection is deterministic. The reflection normal to the wall is 
   * dampened with factor refl. For the floor the reflection has a  
   * random component to bring new 'energy' into the game.
   * 
   * Returns a modified this.sx, .sy, .vx, .vy.
   */
  void applyBoundaryReflections(double dx, double dy)
  {      
    float refl=0.9;		// percent of reflected velocity (normal to the wall)

    // Reflections at floor, ceiling, left and right wall:
    if ((this.sy + dy > floor_y - this.radius)) {			
      dy = floor_y - this.radius - this.sy;

      // the random-floor action:
      this.vy = -random(150)-50;
      this.vx += random(150)-75;
    } else if (this.sy + dy < ceiling_y + this.radius) {  
      dy = ceiling_y + this.radius - this.sy;
      this.vy = - refl*this.vy;
    }

    if (this.sx + dx > rightwall_x - this.radius) {		
      dx = rightwall_x - this.radius - this.sx;
      this.vx = - refl*this.vx;
    } else if (this.sx + dx < leftwall_x + this.radius) {		
      dx = leftwall_x + this.radius - this.sx;
      this.vx = - refl*this.vx;
    }

    this.sx += dx;
    this.sy += dy;

    confineToBox();
  }

  /* 
   * ensure that sphere does not move out of confining box
   */
  void confineToBox() 
  {
    if (this.sx < leftwall_x  + this.radius)  this.sx = leftwall_x  + this.radius;
    if (this.sy < ceiling_y   + this.radius)  this.sy = ceiling_y   + this.radius;
    if (this.sx > rightwall_x - this.radius)  this.sx = rightwall_x - this.radius;
    if (this.sy > floor_y     - this.radius)  this.sy = floor_y     - this.radius;
  }

  /* Clicked mouse */
  void Mouse ()
  {
    if (mouseButton == LEFT)           // if user clicked
    {
      mousedown = true;

    }
  }
  

  /* Released mouse */
  void MouseUp ()
  {
    mousedown = false;
  }

  float Radius() { 
    return (float)radius;
  }
  float Sx() { 
    return (float)sx;
  }
  float Sy() { 
    return (float)sy;
  }
}
