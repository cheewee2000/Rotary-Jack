class Button
{
  int fftBand1;
  int fftBand2; 
  
  float currentValue;
  float lastValue;
  
  boolean isClosed;
  boolean hasChanged;
  
  int closed;
  int opened;
  
  float threshold;
  
  float[] lastValues = {0,0,0,0,0,0,0,0,0,0};
  
  float[] histogram = new float[500];
  
  Button(int fftBand1, int fftBand2, float threshold)
  {
    this.fftBand1 = fftBand1;
    this.fftBand2 = fftBand2;
    
    this.threshold = threshold;
    
    closed = 0;
    opened = 0;
    
    currentValue = getFFTValue();
    lastValue = getFFTValue();
    
    for(int i = 0; i < histogram.length; i++){
      histogram[i] = 0;
    }
    
    histogram[0] = 99;
    
  }
  
  
  void update(){
    lastValue = currentValue;
    currentValue = getFFTValue();
    
    for(int i = 0; i < lastValues.length-1; i++){
      lastValues[i+1] = lastValues[i];
    }
    lastValues[0] = lastValue;
    
    updateHistogram();
    
    checkAbsolute();
    
    //checkDerivative();
  }
  
  void updateHistogram()
  {
    for(int i = histogram.length-1; i > 0; i--)
    {
      histogram[i] = histogram[i-1];
    }
    histogram[0] = currentValue;
    
    println(histogram);
  }
  
  void drawAbsoluteThreshold(int xPos, int yPos, float scale)
  {
    pushStyle();
    stroke(255);
    strokeWeight(1);
    noFill();
    //line(0, height-threshold, 600, height-threshold);
    ellipse(xPos,yPos,threshold*scale, threshold*scale);
    noStroke();
    if( isClosed ) fill(255,0,0);
    if( !isClosed ) fill(255);
    ellipse(xPos,yPos, getFFTValue()*scale, getFFTValue()*scale);
    popStyle();
  }
  
  void drawDerivateThreshold(int xPos, int yPos, float scale)
  {
    pushStyle();
    stroke(255);
    strokeWeight(1);
    noFill();
    //line(0, height-threshold, 600, height-threshold);
    ellipse(xPos,yPos,threshold*scale, threshold*scale);
    noStroke();
    if( isClosed ) fill(255,0,0);
    if( !isClosed ) fill(255);
    
    
    ellipse(xPos,yPos, getFFTDerivate()*scale, getFFTDerivate()*scale);
    
    popStyle();
  }
  
  void drawHistogram()
  {
    pushStyle();
    stroke(255);
    strokeWeight(1);
    noFill();
    
    for(int i = histogram.length-1; i > 0; i--){
      point(histogram.length-i, -histogram[i]/10+300);
    }
    
    popStyle();
      
    
  }
  
  void drawDerivativeHistogram()
  {
    pushStyle();
    stroke(255);
    strokeWeight(1);
    noFill();
    
    for(int i = histogram.length-1; (i-1) > 0; i--){
      point(histogram.length-i, -getFFTDerivate(i)/10+100);
    }
    popStyle();
  }
    
    
  
  
    
  
  void drawCircle(int xPos, int yPos)
  {
    if (this.isClosed()){
      pushStyle();
      fill(255);
      noStroke();
      ellipse(xPos,yPos,50,50);
      popStyle();
    }
  }
  
  float getFFTValue()
  {
    return (soundIn.fft.getBand(fftBand1) + soundIn.fft.getBand(fftBand2));
  }
  
  float getFFTDerivate()
  {
    return currentValue - lastValue;
  }
  
  float getFFTDerivate(int i)
  {
    return histogram[i] - histogram[i-1];
  }
  
  void checkAbsolute()
  {
    if(currentValue > threshold){
      hasChanged = !isClosed ? true : false;
      isClosed = true;
    } else {
      hasChanged = isClosed ? true : false;
      isClosed = false;
    }
  }
  
  void checkDerivative()
  {
    float diff = currentValue - lastValue;
    
    hasChanged = false;
    
    
    
    if( diff > 8.0f ){
      if(!this.isClosed){
        hasChanged = true;
        closed++;
      }
      isClosed = true;
      
    } 
    else if (diff < -5.0f){
      if(this.isClosed){
        hasChanged = true;
        opened++;
      }
      isClosed = false;
    }
    
    
  }
  
  float getAverage()
  {
    float sum = 0;
    for(int i = 0; i < lastValues.length; i++){
      sum += lastValues[i];
    }
    return sum/lastValues.length;
  }
  
  boolean isClosed()
  {
    return isClosed;
  }
  
  boolean hasChanged()
  {
    return hasChanged;
  }
  
}
