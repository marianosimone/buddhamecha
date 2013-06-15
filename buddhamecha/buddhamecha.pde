

PShape s;
int width = 800;
int height = 450;
int background_width = 280;
int background_height = 400;

void setup() {
  size(width, height);
  background(0);
  rectMode(CENTER);
  s = loadShape("buddha.svg");
  s.disableStyle();  // Ignore the colors in the SVG
}

void draw() {}

void mouseDragged() {
  float red = map(mouseX, 0, width, 0, 255);
  float blue = map(mouseY, 0, width, 0, 255);
  float green = dist(mouseX,mouseY,width/2,height/2);

  float speed = dist(pmouseX, pmouseY, mouseX, mouseY);
  float alpha = map(speed, 0, 20, 0, 10);
  float lineWidth = map(speed, 0, 10, 10, 1);
  lineWidth = constrain(lineWidth, 0, 10);

  noStroke();
  fill(0, alpha);
  rect(width/2, height/2, width, height);

  stroke(red, green, blue, 255);
  strokeWeight(lineWidth);

  line(pmouseX, pmouseY,mouseX, mouseY);
  shape(s, (width/2.0)-(background_width/2.0), (height/2.0)-(background_height/2.0), background_width, background_height);  
}

void mouseReleased() {
  println("mouse released");
}

void mousePressed() {
  println("mouse pressed");
}
