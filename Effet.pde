public class Effet {
    CBalls cBalls; 

    Effet(CBalls balls) {
        this.cBalls = balls;
    }

    public void draw() {
        for (Ball ball : cBalls.balls) {
            ball.makeEffet = true; 
            //TODO

            // Übung:
            // Passe den Winkel des Balls so an, dass die draw() Methode immer wieder den aktuellen Winkel verwendet,
            // und somit den Ball mit einem neuen Winkel projizieren kann.
            //
            // Die Formel, die wir hier verwenden ist: Winkel = v / r,
            // wobei v die Geschwindigkeit des Balls und r der Radius des Balls ist.


            // Hinweis für Studierende:
            //   float angleX       
            //   float angleY       
            //   double vx, vy      Aktuelle Geschwindigkeit in x / y Richtung
            //   float radius       Ball Radius            
        }
    }

    public void resetBallFlags() {
        for (Ball ball : cBalls.balls) {
            ball.makeEffet = false;  
        }
    }
}

