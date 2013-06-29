//import ddf.minim.analysis.*;
//import ddf.minim.*;
import beads.*;
import java.io.File;
  
class MusicController {
  Maxim maxim;
  int current_player = 0;
  AudioPlayer[] players;
  //ddf.minim.analysis.FFT[] transformations;

  MusicController(String directory, Maxim maxim) {
    this.maxim = maxim;
    StringList files = getFiles(directory);
    players = new AudioPlayer[files.size()];
    //transformations = new ddf.minim.analysis.FFT[files.size()];
    int i = 0;
    for (String file: files) {
      players[i] = maxim.loadFile(file);
      players[i].setLooping(true);
      //transformations[i] = new ddf.minim.analysis.FFT(players[i].bufferSize(), players[i].sampleRate());
      i += 1;
    }
  }

  AudioPlayer current_player() {
    return players[current_player];
  }

  void play() {
    current_player().cue(0);
    current_player().setAnalysing(true);
    current_player().play(); 
  }

  float getSample() {
    return current_player().getAveragePower();
    /*ddf.minim.analysis.FFT fft = transformations[current_player];
    fft.forward(current_player().mix);
    float total = 0.0;
    for(int i = 0; i < fft.specSize(); i++) {
      total += fft.getBand(i);
    }
    return total/fft.specSize();
    */
  }

  void stop() {
    /*for (AudioPlayer player: players) {
      player.stop();
    }
    maxim.stop();
    */
  }

  void change() {
    current_player().stop();
    current_player().setAnalysing(false);
    if (current_player+1 < players.length) {
      current_player += 1;
    } else {
      current_player = 0;
    }
    play();
  }

  StringList getFiles(String dirPath) {
    File dir = new File(dirPath);
    File[] files = dir.listFiles();
    StringList music =  new StringList();
    for( int i=0; i < files.length; i++ ){ 
      String path = files[i].getAbsolutePath();
      if( path.toLowerCase().endsWith(".wav") ) {
        music.append(path);
      }
    }
    return music;
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
