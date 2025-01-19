public class Effet {
    CBalls cBalls; 

    Effet(CBalls balls) {
        this.cBalls = balls;
    }

    public void draw() {
        for (int i = 0; i < cBalls.ball.length; i++) {
            cBalls.ball[i].makeEffet = true; 
            cBalls.ball[i].angleX += cBalls.ball[i].vx * 0.1 / cBalls.ball[i].radius;
            cBalls.ball[i].angleY += cBalls.ball[i].vy * 0.1 / cBalls.ball[i].radius; 
        }
    }

    public void resetBallFlags() {
        for (int i = 0; i < cBalls.ball.length; i++) {
            cBalls.ball[i].makeEffet = false;  
        }
    }
}
