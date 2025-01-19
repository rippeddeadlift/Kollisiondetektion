public class Effet {
    CBalls cBalls; 

    Effet(CBalls balls) {
        this.cBalls = balls;
    }

    public void draw() {
        for (Ball ball : cBalls.balls) {
            ball.makeEffet = true; 
            ball.angleX += ball.vx * 0.07 / ball.radius;
            ball.angleY += ball.vy * 0.07 / ball.radius;  
        }
    }

    public void resetBallFlags() {
        for (Ball ball : cBalls.balls) {
            ball.makeEffet = false;  
        }
    }
}


// Übung:
// Die Formel, die wir hier verwenden ist: Winkel = v / r,
// wobei v die Geschwindigkeit des Balls und r der Radius des Balls ist.

// Passe den Winkel des Balls so an, dass die draw() Methode immer wieder den aktuellen Winkel verwendet,
// und somit den Ball mit einem neuen Winkel projizieren kann.

// Hinweis für Studierende:
//   float angleX       
//   float angleY       
//   double vx, vy      Aktuelle Geschwindigkeit in x / y Richtung
//   float radius       Ball Radius


