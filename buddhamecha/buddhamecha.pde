

PShape buddha_shape;
PShape lotus_shape;
int width;
int height;
int background_width = 280;
int background_height = 400;
float maxDistance;

MusicController background_music;
EffectPlayer bell;

void setup() {
  width = displayWidth;
  height = displayHeight;
  maxDistance = (float)Math.floor(Math.sqrt(Math.pow(width/2, 2) + Math.pow(height/2, 2)));
  size(width, height);
  background(0);
  rectMode(CENTER);
  buddha_shape = loadShape("buddha.svg");
  buddha_shape.disableStyle();  // Ignore the colors in the SVG
  lotus_shape = loadShape("lotus.svg");
  lotus_shape.disableStyle();  // Ignore the colors in the SVG
  background_music = new MusicController(new String[]{"dong.mp3", "chun.mp3", "qiu.mp3", "xia.mp3"}, new Minim(this));
  bell = new EffectPlayer(dataPath("bell.wav"));
  background_music.play();
}

void stop() {
  background_music.stop();
  super.stop();
}

color[] colors = new color[] {#EBC51C, #213CB1, #D80913, #FFFFFF, #E35604};
void lotus(int x, int y, int intensity) {
    int size = int(random(10,70));
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
  fill(0.0, 15.0);
  rect(width/2, height/2, width, height);
  buddha();
  int sample = background_music.getSample();
  if (sample > 80) {
    lotus(int(random(0, width)), int(random(0, height)), sample);
  }
}

/**
 * Change the background music if hitting the spacebar
**/
void keyPressed() {
  if (int(key) == 32) {
    background_music.change();
  }
}

float distanceToCenter() {
 return (float)Math.floor(Math.sqrt(Math.pow(mouseX - width/2, 2) + Math.pow(mouseY - height/2, 2))); 
}
void mouseClicked() {
  float volume = map(distanceToCenter(), 0.0, maxDistance, 2.0, 0.0);
  bell.play(volume);
}

