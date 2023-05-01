class Boid {
  PVector velocity;
  PVector position;

  Boid(float x, float y) {
    // randomise the velocity
    float angle = random(TWO_PI);
    velocity = new PVector(cos(angle), sin(angle));
    position = new PVector(x, y);
  }

  void limitSpeed() {
    float maxMag = 0.2;
    if (velocity.mag() > maxMag)
    {
      velocity = (velocity.div(velocity.mag())).div(maxMag);
    }
  }

  void stayInFrame() {
    if (position.x > width) {
      position.x -= width;
    }
    if (position.y > height) {
      position.y -= height;
    }
    if (position.x < 0) {
      position.x += width;
    }
    if (position.y < 0) {
      position.y += height;
    }
  }

  void render(boolean angle_avoidance_mode) {
    if (angle_avoidance_mode) {
      renderTriangle();
    } else {
      renderSquare();
    }
  }

  private void renderSquare() {
    fill(200, 100);
    stroke(255);
    rect(position.x, position.y, 10, 10);
  }

  private void renderTriangle() {
    // Draw a triangle rotated in the direction of velocity
    // Referenced from https://processing.org/examples/flocking.html
    float theta = velocity.heading() + radians(90);
    fill(200, 100);
    stroke(255);
    pushMatrix();
    translate(position.x, position.y);
    rotate(theta);
    beginShape(TRIANGLES);
    vertex(0, -2*2);
    vertex(-2, 2*2);
    vertex(2, 2*2);
    endShape();
    popMatrix();
  }
}
