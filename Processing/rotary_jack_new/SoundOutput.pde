class SoundOutput
{
  
  AudioOutput outLeft;
  AudioOutput outRight;

  Oscil       waveLeft;
  Oscil       waveRight;
  
  Pan         panLeft;
  Pan         panRight;
  

  
  public SoundOutput(int freqLeft, int freqRight)
  {
    outLeft = minim.getLineOut(Minim.STEREO, 1024);
    outRight = minim.getLineOut(Minim.STEREO, 1024);
    
    waveLeft = new Oscil( freqLeft, 0.6f, Waves.SINE );
    waveRight = new Oscil( freqRight, 0.6f, Waves.SINE );
    
    panLeft = new Pan(0);
    waveLeft.patch(panLeft); 
    waveLeft.patch( outLeft );
    outLeft.setPan(-1);
  
    panRight = new Pan(0);
    waveRight.patch(panLeft); 
    waveRight.patch( outRight );
    outRight.setPan(1);
  }
  
  void drawWave()
  {
    pushStyle();
    stroke(255);
    strokeWeight(1);
  
    // draw the waveform of the output
    for(int i = 0; i < outLeft.bufferSize() - 1; i++)
    {
      line( i, 50  - outLeft.left.get(i)*50,  i+1, 50  - outLeft.left.get(i+1)*50 );
      line( i, 150 - outRight.mix.get(i)*50, i+1, 150 - outRight.mix.get(i+1)*50 );
    }
    popStyle();
  }
  
}
