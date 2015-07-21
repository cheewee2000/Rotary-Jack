import ddf.minim.*;
import ddf.minim.ugens.*;
import ddf.minim.analysis.*;

Minim       minim;
AudioOutput outLeft;
AudioOutput outRight;

Oscil       waveLeft;
Oscil       waveRight;
Pan         panLeft;
Pan         panRight;

AudioInput  in;
FFT         fft;



// none: 0, left: 1, right: 2, both: 3
int         lastRotarySignal = 0;
int         rotaryValue = 0;
int         a = 0;
int         b = 0;

void setup()
{
  size(1000, 400, P3D);
  smooth();
  
  minim = new Minim(this);
  
  // use the getLineOut method of the Minim object to get an AudioOutput object
  //out = minim.getLineOut(Minim.STEREO, 1024);
  outLeft = minim.getLineOut(Minim.STEREO, 1024);
  outRight = minim.getLineOut(Minim.STEREO, 1024);
  
  
  // create a sine wave Oscil, set to 440 Hz, at 0.5 amplitude
  waveLeft = new Oscil( 18000, 0.5f, Waves.SINE );
  waveRight = new Oscil( 20000, 0.5f, Waves.SINE );

  
  panLeft = new Pan(0);
  waveLeft.patch(panLeft); 
  waveLeft.patch( outLeft );
  outLeft.setPan(-1);
  
  panRight = new Pan(0);
  waveRight.patch(panLeft); 
  waveRight.patch( outRight );
  outRight.setPan(1);

  //panRight = new Pan(1);
  //waveRight.patch(panRight);
  
  
  // patch the Oscils to the output
  //waveRight.patch( out );

 

  in = minim.getLineIn(Minim.MONO);
  fft = new FFT( in.bufferSize(), in. sampleRate() );
  
  frameRate(600);

  
}

void draw()
{
  
  background(0);

  findHighestFreq();

  rotaryValue += checkInput(); 
  //checkInput();
  //println(rotaryValue);
  
  drawRotary();
  
  //drawOutWave();
  fft.forward(in.mix);
  drawInWave();
  
  text("FPS: " + frameRate, 10,20);
  text("A: " + a, 10,30);
  text("B: " + b, 10,40);
  
  
  
 
}

void drawRotary()
{
  pushStyle();
    noFill();
    stroke(255);
    pushMatrix();
      translate(800, 300);
      ellipse(0, 0, 150, 150);
      textSize(32);
      text(rotaryValue, -150, 0);

      rotate( 2*PI /100 * rotaryValue);
      line(0,0, 0, -75);
      rotate(PI/2);
      textSize(10);
      text(rotaryValue, -100, 0);
      
    popMatrix();
    
    //fill(0,0,0,255);
    //stroke(255);
    //ellipse(800, 300, 50, 50);

    
  popStyle();
  
  

}


int checkInput()
{
  
  int rotarySignal = 0;
  
  
  if (checkRight() && checkLeft()){
    pushStyle();
    fill(255);
    noStroke();
    ellipse(900,150, 50,50);
    popStyle();
    rotarySignal = 3;
    
    if(lastRotarySignal != 3) { b++; };
  }
  else if (checkRight())
  {
    pushStyle();
    fill(255);
    noStroke();
    ellipse(900,150, 50,50);
    popStyle();
    rotarySignal = 2;
    
    if(lastRotarySignal != 2) { b++; };
  }
  else if (checkLeft())
  {
    pushStyle();
    fill(255);
    noStroke();
    ellipse(900,50, 50,50);
    popStyle();
    rotarySignal = 1;
    
    if(lastRotarySignal != 1) { a++; };
    
  } 
  

  
  int movement = 0;  
  
  
  if(lastRotarySignal == rotarySignal){
    return 0;
  } else {
    
    /*
    switch (rotarySignal){
      case 0:    
      movement = (lastRotarySignal == 2) ? 1 : -1;
      break;
      
      case 1:
      movement = (lastRotarySignal == 0) ? 1: -1;
      break;
      
      case 2:
      movement = (lastRotarySignal == 1) ? 1: -1;
      break;
    }
    */
    
    switch (rotarySignal){
      case 0:    
      movement = (lastRotarySignal == 2) ? -1 : 1;
      break;
      
      case 1:
      movement = (lastRotarySignal == 3) ? 1: -1;
      break;
      
      case 2:
      movement = (lastRotarySignal == 0) ? 1: -1;
      break;
      
      case 3:
      movement = (lastRotarySignal == 2) ? 1 : -1;
      break;
    }
    

    
  }
  
  lastRotarySignal = rotarySignal;
    
  return movement;

}
    

boolean checkLeft()
{
  
  //print("left: ");
  //print(fft.getBand(208) + fft.getBand(209) + fft.getBand(210));
  
  
  if((fft.getBand(209) + fft.getBand(303)) > 100){
    return true;
  } else {
    return false;
  }
}

boolean checkRight()
{
  
  //print(", right: ");
  //println((fft.getBand(231) + fft.getBand(232) + fft.getBand(233)));
  
  if((fft.getBand(232) + fft.getBand(280)) > 100){
    return true;
  } else {
    return false;
  }
}

void findHighestFreq()
{
  int highestIndex = 0;
  int secondHighestIndex = 0;
  
  float[] temp = new float[fft.specSize()];
  
  for(int i = 0; i < fft.specSize(); i++)
  {
    
    temp[i] = fft.getBand(i);
    
    if (fft.getBand(i) > fft.getBand(highestIndex)){
      secondHighestIndex = highestIndex;
      highestIndex = i;
    }
  }
  
  temp = sort(temp);
  temp = reverse(temp);
  
  
  
  for(int i = 0; i < 10; i++){
    print(findFFTElement(temp[i]));
    print(":");
    print(int(temp[i]));
    print(", ");
  }
  println();
  println();
  
}
    



void drawOutWave()
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




void drawInWave()
{
  
  pushStyle();
    stroke(255);
    strokeWeight(1);
    
    for(int i = 0; i < fft.specSize(); i++)
    {
      line(i, height, i, height - fft.getBand(i) * 1);
    }
    
  popStyle();
}
    
    


void keyPressed()
{ 
  /*
  if (key == CODED)
  {
    switch (keyCode)
    {
      case LEFT:
        out.setPan(-1);
        break;
      case RIGHT:
        out.setPan(1);
        break;
      case UP:
        out.setPan(0);
        break;
    }
  }
  */  
  
  switch( key )
  {
    case '1': 
      waveLeft.setFrequency( 500 );
      break;
     
    case '2':
      waveLeft.setFrequency( 1000 );
      break;
     
    case '3':
      waveLeft.setFrequency( 10000 );
      break;

    
     
    default: break; 
  }
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
  
