import beads.*;

PShape buddha_shape;
PShape lotus_shape;
int width;
int height;
int background_width = 280;
int background_height = 400;

AudioContext ac;
Gain g;


MusicController background_music;

void setup() {
  width = 900;//displayWidth;
  height = 400;//displayHeight;
  size(width, height);
  background(0);
  rectMode(CENTER);
  buddha_shape = loadShape("buddha.svg");
  buddha_shape.disableStyle();  // Ignore the colors in the SVG
  lotus_shape = loadShape("lotus.svg");
  lotus_shape.disableStyle();  // Ignore the colors in the SVG
  minim = new Minim(this);
  background_music = new MusicController(new String[]{"dong.mp3", "chun.mp3", "qiu.mp3", "xia.mp3"}, true);
  background_music.play();
  ac = new AudioContext();
  g = new Gain(ac, 1, 0.5);

  ac.out.addInput(g);
  ac.start();
}

void stop() {
  background_music.stop();
  minim.stop();
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

void keyPressed() {
  if (int(key) == 32) {
    background_music.change();
  }
}

void mouseClicked() {
  String sourceFile = dataPath("bell.wav");
  try{
    SamplePlayer sp = new SamplePlayer(ac, new Sample(sourceFile));
    //sp.setRate(new Glide(ac, int(random(0,100))));
    sp.setKillOnEnd(true);
    g.addInput(sp);
    sp.start();
  } catch (Exception e) {
    e.printStackTrace();
  }
}

