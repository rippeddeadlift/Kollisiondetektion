public class InputWindow extends PApplet {
  boolean windowOpen = false;
  String userInput = "";
  EffetDemo effetDemo;

  public InputWindow(EffetDemo effetDemo) {
    this.effetDemo = effetDemo;
  }

  public void settings() {
    size(400, 200);
  }

  public void setup() {
    background(200);
      fill(0);
      text("Spinfaktor einsetzen", 10, 50);
      text("Deine Eingabe: " + userInput, 10, 90);
  }

  public void draw() {
    if (windowOpen) {
      background(200);
      fill(0);
      text("Nicht getroffen",10,30);
      text("Probier es mit einem anderen SpinFaktor", 10, 50);
      text("Der letzte SpinFaktor war " + effetDemo.ball.spinFactor*100, 10, 70);
      text("Deine Eingabe: " + userInput, 10, 90);
    }
  }

  public void keyPressed() {
    if (key == ENTER) {
      try {
        float newSpinFactor = Float.parseFloat(userInput);
        effetDemo.updateSpinFactor(newSpinFactor);
      } catch (NumberFormatException e) {
        println("Bitte gültige Nummer eingeben");
      }
      windowOpen = false;
      surface.setVisible(false);
    } else if (key == BACKSPACE) {
      if (userInput.length() > 0) {
        userInput = userInput.substring(0, userInput.length() - 1);
      }
    } else {
      userInput += key;
    }
  }

  public void openWindow() {
    windowOpen = true;
    surface.setVisible(true);
  }

  @Override
  public void exit() {
    windowOpen = false;
    surface.setVisible(false);
  }
}
