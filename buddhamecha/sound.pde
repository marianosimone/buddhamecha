import ddf.minim.analysis.*;
import ddf.minim.*;
import beads.*;

class MusicController {
  Minim minim;
  int current_player = 0;
  AudioPlayer[] players;
  ddf.minim.analysis.FFT[] transformations;

  MusicController(String[] files, Minim minim) {
    this.minim = minim;
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
    minim.stop();
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

class EffectPlayer {
  AudioContext ac;
  SamplePlayer sp;
  OnePoleFilter filter;
  Glide gainValue;

  EffectPlayer(final String path) {
    ac = new AudioContext(); // create our AudioContext
    try {  
      sp = new SamplePlayer(ac, new Sample(path));
    }
    catch(Exception e) {
      println("Exception while attempting to load sample!");
      e.printStackTrace(); // then print a technical description of the error
    }
    sp.setKillOnEnd(false);

    filter = new OnePoleFilter(ac, 200.0); // set up our new filter with a cutoff frequency of 200Hz
    filter.addInput(sp); // connect the SamplePlayer to the filter

    gainValue = new Glide(ac, 0.0, 20);
    Gain g = new Gain(ac, 1, gainValue);
    g.addInput(filter); // connect the filter to the gain
    ac.out.addInput(g); // connect the Gain to the AudioContext
    ac.start(); // begin audio processing
  }

  void play(float value) {
    filter.setFrequency(20000.0); // set the filter frequency to cutoff at 20kHz -> the top of human hearing
    gainValue.setValue(value);
    sp.setToLoopStart(); // move the playback pointer to the first loop point (0.0)
    sp.start();
  }
}
