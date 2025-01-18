public class Effet {
    CBalls cBalls; 

    Effet(CBalls balls) {
        this.cBalls = balls;
    }

    public void draw() {
        for (int i = 0; i < cBalls.ball.length; i++) {
            cBalls.ball[i].angleX += cBalls.ball[i].vx * 0.015 / cBalls.ball[i].radius;
            cBalls.ball[i].angleY += cBalls.ball[i].vy * 0.015 / cBalls.ball[i].radius;
            cBalls.ball[i].makeEffet = true;  
        }
    }

    public void resetBallFlags() {
        for (int i = 0; i < cBalls.ball.length; i++) {
            cBalls.ball[i].makeEffet = false;  
        }
    }
}
