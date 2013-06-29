

PShape buddha_shape;
PShape lotus_shape;
int width;
int height;
int background_width = 280;
int background_height = 400;
float maxDistance;
float threshold = 0.01;
int wait = 0;
int sampleRatio = 10;
int min_lotus = 30;
int max_lotus = 100;
float latest_power = 0;

MusicController background_music;
EffectPlayer bell;

void setup() {
  width = displayWidth;
  height = displayHeight;
  maxDistance = dist(width/2, height/2, 0, 0);
  size(width, height);
  background(0);
  rectMode(CENTER);
  buddha_shape = loadShape("buddha.svg");
  buddha_shape.disableStyle();  // Ignore the colors in the SVG
  lotus_shape = loadShape("lotus.svg");
  lotus_shape.disableStyle();  // Ignore the colors in the SVG
  background_music = new MusicController(dataPath("fm3/chanfang"), new Maxim(this));
  bell = new EffectPlayer(dataPath("bell.wav"));
  background_music.play();
}

void stop() {
  background_music.stop();
  super.stop();
}

color[] colors = new color[] {#EBC51C, #213CB1, #D80913, #FFFFFF, #E35604};
void lotus(int x, int y, float intensity) {
    int size = int(map(intensity, 0.0, 1.0, min_lotus, max_lotus));
    stroke(colors[int(random(0, colors.length))], int(random(100,255)));
    shape(lotus_shape, x, y, size, size);
}

void buddha() {
    fill(0, 0);
    stroke(100,100,100,255);
    strokeWeight(5);
    shape(buddha_shape, (width/2.0)-(background_width/2.0), (height/2.0)-(background_height/2.0), background_width, background_height);
}

void draw() {
  noStroke();
  fill(0.0, 10.0);
  rect(width/2, height/2, width, height);
  buddha();
  float power = background_music.getSample();
  if (power > latest_power && power > threshold && wait < 0) {
      wait+=sampleRatio;
      lotus(int(random(0, width)), int(random(0, height)), power);
    }
    latest_power = power;
    wait--;
}

/**
 * Change the background music if hitting the spacebar
**/
void keyPressed() {
  if (int(key) == 32) {
    background_music.change();
    fill(0, 255);
    stroke(0, 0);
    rect(width/2, height/2, width, height);
  }
}

float distanceToCenter() {
 return dist(mouseX, mouseY, width/2, height/2); 
}
void mouseClicked() {
  float volume = map(distanceToCenter(), 0.0, maxDistance, 2.0, 0.0);
  bell.play(volume);
}

void mouseMoved() {
  min_lotus = int(map(distanceToCenter(), 0.0, maxDistance, 10, 50));
  max_lotus = min_lotus*2;
}
