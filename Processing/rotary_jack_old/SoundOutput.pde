class SoundOutput{
  
  AudioOutput outLeft;
  AudioOutput outRight;
  
  Oscil       waveLeft;
  Oscil       waveRight;
  
  Pan         panLeft;
  Pan         panRight;
  
  SoundOutput(int freqLeft, int freqRight)
  {
    outLeft = minim.getLineOut(Minim.STEREO, 1024);
    outRight = minim.getLineOut(Minim.STEREO, 1024);
    
    waveLeft = new Oscil( freqLeft, 0.5f, Waves.SINE );
    waveRight = new Oscil( freqRight, 0.5f, Waves.SINE );
    
    panLeft = new Pan(0);
    waveLeft.patch(panLeft); 
    waveLeft.patch( outLeft );
    outLeft.setPan(-1);
  
    panRight = new Pan(0);
    waveRight.patch(panLeft); 
    waveRight.patch( outRight );
    outRight.setPan(1);
  }
  
  
  void start()
  {
    
  }
  
  void stop()
  {
    
  }
  
  void run()
  {
    
  }
    
    
    
  
  
}
