Flock flock;
boolean angle_avoidance_mode = false;
boolean inside_button = false;
int circleX, circleY;
int circleSize = 93;

void setup() {
  size(1280, 720);
  circleX = width - 100;
  circleY = height - 100; 
  frameRate(30);
  ellipseMode(CENTER);
  flock = new Flock(200);
}

void draw() {
  update(mouseX, mouseY);
  background(50);
  flock.update(angle_avoidance_mode);
  
  if (inside_button) {
    fill(255, 0, 0);
  } else {
    fill(0,0, 255);
  }
  stroke(0);
  ellipse(circleX, circleY, circleSize, circleSize);
}

void update(int x, int y) {
  if ( overCircle(circleX, circleY, circleSize) ) {
    inside_button = true;
  } else {
    inside_button = false;
  }
}

void mousePressed() {
  if (inside_button) {
    angle_avoidance_mode = ! angle_avoidance_mode;
  }
}

// button code referenced from: https://processing.org/examples/button.html
boolean overCircle(int x, int y, int diameter) {
  float disX = x - mouseX;
  float disY = y - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
    return true;
  } else {
    return false;
  }
}
