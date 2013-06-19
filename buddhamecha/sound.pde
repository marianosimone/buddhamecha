import ddf.minim.analysis.*;
import ddf.minim.*;

Minim minim;

class MusicController {
  int current_player = 0;
  AudioPlayer[] players;
  ddf.minim.analysis.FFT[] transformations;

  MusicController(String[] files, boolean looping) {
    players = new AudioPlayer[files.length];
    transformations = new ddf.minim.analysis.FFT[files.length];
    int i = 0;
    for (String file: files) {
      players[i] = minim.loadFile(file, 1024*4);
      transformations[i] = new ddf.minim.analysis.FFT(players[i].bufferSize(), players[i].sampleRate());
      i += 1;
    }
  }

  AudioPlayer current_player() {
    return players[current_player];
  }

  void play() {
    current_player().cue(0);
    current_player().loop(); 
  }

  int getSample() {
    ddf.minim.analysis.FFT fft = transformations[current_player];
    fft.forward(current_player().mix);
    int total = 0;
    for(int i = 0; i < fft.specSize(); i++) {
      total += fft.getBand(i);
    }
    return total;
  }

  void stop() {
    for (AudioPlayer player: players) {
      player.close();
    }
  }

  void change() {
    current_player().pause();
    if (current_player+1 < players.length) {
      current_player += 1;
    } else {
      current_player = 0;
    }
    play();
  }
}

