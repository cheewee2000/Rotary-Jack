class SoundInput
{
  AudioInput  in;
  FFT         fft;
  float[]     oldFFT;
  
  
  SoundInput()
  {
    in = minim.getLineIn(Minim.MONO);
    fft = new FFT( in.bufferSize(), in. sampleRate() );
    oldFFT = new float[fft.specSize()];
  }
  
  void update(){
    
    for(int i = 0; i < oldFFT.length; i++){
      oldFFT[i] = fft.getBand(i);
    }
    
    fft.forward(in.mix);
  }
  
  void drawDerivativeFFT()
  {
    pushStyle();
    stroke(255,0,0);
    strokeWeight(1);
    
    for(int i = 0; i < oldFFT.length; i++)
    {
      line(i, height/2, i, height/2 - (fft.getBand(i)-oldFFT[i]) * 0.2);
    }
    
    popStyle();
  }
    
  
  void drawFFT()
  {
    pushStyle();
    stroke(255);
    strokeWeight(1);
    
    for(int i = 0; i < fft.specSize(); i++)
    {
      line(i, height, i, height - fft.getBand(i) * 0.2);
    }
    
    popStyle();
  }
  
  int findFFTElement(float val)
  {
    for(int i = 0; i < fft.specSize(); i++)
    {    
      if (fft.getBand(i) == val){
        return i;
      }
    }
    return -1;
  }
  
  
  int findHighestFreq()
  {
    int highestIndex = 0;
    for(int i = 0; i < fft.specSize(); i++)
    {    
      if (fft.getBand(i) > fft.getBand(highestIndex)){
        highestIndex = i;
      }
    }
    return highestIndex;
  }
  
  void printHighestFreqs(int size)
  {
    
    float[] temp = new float[fft.specSize()];
    for(int i = 0; i < fft.specSize(); i++)
    {
      temp[i] = fft.getBand(i);
    }
    temp = sort(temp);
    temp = reverse(temp);
    
    for(int i = 0; i < size; i++){
      print(findFFTElement(temp[i]) + ":");
      print(int(temp[i]) + "' ");
    }
    println();
    println();
  }
    
      
      


  
  
}
