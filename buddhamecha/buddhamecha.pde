import beads.*;
import ddf.minim.*;

PShape buddha_shape;
PShape lotus_shape;
int width = 800;
int height = 450;
int background_width = 280;
int background_height = 400;
Maxim maxim;
Minim minim;
AudioSample bell;
AudioContext ac;
Gain g;

class MusicController {
  int current_player = 0;
  boolean looping;
  AudioPlayer[] players;

  MusicController(String[] files, boolean looping) {
    players = new AudioPlayer[files.length];
    this.looping = looping;
    int i = 0;
    for (String file: files) {
      players[i] = maxim.loadFile(file);
      players[i].setLooping(looping);
      i += 1;
    }
  }

  AudioPlayer current_player() {
    return players[current_player];
  }

  void play() {
    current_player().play(); 
  }

  void speed(float speed) {
    current_player().speed(speed);
  }

  short getSample() {
    return current_player().getSample();
  }

  void stop() {
    for (AudioPlayer player: players) {
     // player.close();
    }
  }
  void change() {
    if (this.looping) {
      current_player().stop();
    }
    if (current_player+1 < players.length) {
      current_player += 1;
    } else {
      current_player = 0;
    }
    play();
  }
}

MusicController background_music;

void setup() {
  size(width, height);
  background(0);
  rectMode(CENTER);
  buddha_shape = loadShape("buddha.svg");
  buddha_shape.disableStyle();  // Ignore the colors in the SVG
  lotus_shape = loadShape("lotus.svg");
  lotus_shape.disableStyle();  // Ignore the colors in the SVG
  maxim = new Maxim(this);
  minim = new Minim(this);
  background_music = new MusicController(new String[]{ "dong.wav"/*, "chun.wav","qiu.wav", "xia.wav"*/}, true);
  background_music.play();
  bell = minim.loadSample("15401__djgriffin__tibetan-bell.wav", 512);
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
  fill(0, 7.0);
  rect(width/2, height/2, width, height);
  buddha();
  short sample = background_music.getSample();
  if (sample > 500) {
    lotus(int(random(0, width)), int(random(0, height)), sample);
  }
}

boolean dragging = false;
void mouseReleased() {
 dragging = false; 
}

void mouseDragged() {
  if (!dragging) {
    background_music.change();
    dragging = false;
  }
}

void mouseClicked() {
  dragging = true;
  
  String sourceFile = dataPath("15401__djgriffin__tibetan-bell.wav");
  try{
    SamplePlayer sp = new SamplePlayer(ac, new Sample(sourceFile));
    sp.setRate(new Glide(ac, int(random(0,100))));
    sp.setKillOnEnd(true);
    g.addInput(sp);
    sp.start();
  } catch (Exception e) {
    e.printStackTrace();
  }
  //bell.setGain(random(0,255));
  //bell.trigger();
}
