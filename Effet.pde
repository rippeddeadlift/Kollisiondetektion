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
