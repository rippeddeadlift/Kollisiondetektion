class TextDrawer{
  
  
  final String LOW_FPS_HINT_TEXT = "Niedrige FPS, hohe Geschwindigkeit des Elements \n Drücke T um den Modus zu wechseln";
  final String HIGH_FPS_HINT_TEXT = "Hohe FPS, moderate Geschwindigkeit des Elements, \n Drücke T um den Modus zu wechseln";
  PFont font = createFont("Cascadia Code", 12);
  PGraphics pg;
  
  public PGraphics setupMenuText(){
    float mid_x = width/2;
    pg = createGraphics(width, height);
    pg.beginDraw();
    pg.textFont(font);
    pg.fill(255, 255, 255);
    pg.text("1: Root Mode / Normalmode ", 10, 35);
    pg.text("2: Kollisiondetektion", 10, 35 + 1 * 25);
    pg.text("3: Impuls Demonstration", 10, 35 + 2 * 25);
    pg.text("4: Tunneling Demonstration", 10, 35 + 3 * 25);
    pg.text("e: Drehung",mid_x,35);
    pg.text("v: Bewegungsvektoren anzeigen",mid_x,35+1*25);
    pg.text("x: Algorithmus Toggle",mid_x,35+2*25);
    pg.text("y: Verbindungslinien anzeigen",mid_x,35+3*25);
    pg.text("SPACE: Anhalten",mid_x,35+4*25);
    pg.endDraw();
    return pg;
  }
  
  public void displayImpulseHintText(){
    fill(color(255, 255, 255));
    text("Ball linksclick: +10% Masse, +5% Radius", width/2, 600 + 2 * 25);
    text("Ball Rechtsclick: -10% Masse, -5% Radius", width/2, 600 + 3 * 25);
  }
  
  public PGraphics setupTunnelingDemoHintText(boolean isInHighFps){
    pg = createGraphics(width, height);

    pg.beginDraw();
    pg.textFont(font);
    pg.fill(color(255, 255, 255));
    if(isInHighFps){
      pg.text(HIGH_FPS_HINT_TEXT, width/2,650 );
    }else{
      pg.text(LOW_FPS_HINT_TEXT, width/2,650);
    }
    pg.endDraw();
    return pg;
  }
  
  public void displayCurrentFps(){
    fill(color(255, 255, 255));
    text("Aktuelle FPS: " + frameRate, 10, 600 + 2 * 25);
  }
  public void displayAmountOfElements(int amount){
    fill(color(255, 255, 255));
    text("Anzahl Elemente: " + amount, 10, 600 + 3 * 25);
  }
}
