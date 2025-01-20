class ConnectionDrawer{

  public void draw(Ball b1, Ball b2) {
      stroke(color(255,255,0));
      strokeWeight(1);
      line(b1.Sx(), b1.Sy(), b2.Sx(), b2.Sy());
  }
}
