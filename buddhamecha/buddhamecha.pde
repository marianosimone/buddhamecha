PShape buddha_shape;
PShape lotus_shape;
int width = 800;
int height = 450;
int background_width = 280;
int background_height = 400;
Maxim maxim;

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

  void change() {
    //if (this.looping) {
      current_player().stop();
    //}
    if (current_player+1 < players.length) {
      current_player += 1;
    } else {
      current_player = 0;
    }
    play();
  }
}

MusicController background_music;
MusicController effects;

void setup() {
  size(width, height);
  background(0);
  rectMode(CENTER);
  buddha_shape = loadShape("buddha.svg");
  buddha_shape.disableStyle();  // Ignore the colors in the SVG
  lotus_shape = loadShape("lotus.svg");
  lotus_shape.disableStyle();  // Ignore the colors in the SVG
  maxim = new Maxim(this);
  background_music = new MusicController(new String[]{ "dong.wav"/*, "chun.wav","qiu.wav", "xia.wav"*/}, true);
  background_music.play();
  effects = new MusicController(new String[]{ "15401__djgriffin__tibetan-bell.wav"}, false);
}

void lotus(int mouseX, int mouseY) {
    int size = int(random(10,70));
    shape(lotus_shape, mouseX, mouseY, size, size);
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
    stroke(map(sample, 0, 1500, 0, 255), map(sample, 0, 1500, 0, 255), map(sample, 0, 1500, 0, 255), 255);
    lotus(int(random(0, width)), int(random(0, height)));
  }
}

void mouseDragged() {
  float red = map(mouseX, 0, width, 0, 255);
  float blue = map(mouseY, 0, width, 0, 255);
  float green = dist(mouseX,mouseY,width/2,height/2);

  float speed = dist(pmouseX, pmouseY, mouseX, mouseY);
  float alpha = map(speed, 0, 20, 0, 10);
  float lineWidth = map(speed, 0, 10, 10, 1);
  lineWidth = constrain(lineWidth, 0, 10);

  stroke(red, green, blue, 255);
  strokeWeight(lineWidth);

  lotus(mouseX, mouseY);
}

void mouseMoved() {
  //controller.speed((float)map(mouseY, 0, height, 1, 3));
}

void mouseClicked() {
  effects.change();
}
