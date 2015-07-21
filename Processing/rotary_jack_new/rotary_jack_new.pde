// next step: compare derivative with absolute measurement
// hardware: cap or no cap?
// hardware: charge a cap and discharge with 

import ddf.minim.*;
import ddf.minim.ugens.*;
import ddf.minim.analysis.*;

Minim       minim;
SoundOutput soundOut;
SoundInput  soundIn;

Rotary      rotary;
Button      button;

void setup()
{
  size(1000, 400, "processing.core.PGraphicsRetina2D");
  hint(ENABLE_RETINA_PIXELS);
  smooth(8);
  
  minim = new Minim(this);
  
  soundOut = new SoundOutput(15000, 20000);
  soundIn = new SoundInput();
  
  rotary = new Rotary(174, 338, 232, 280, 100, 100);
  button = new Button(174, 338, 100);
  
  frameRate(60);
}

void draw()
{  
  background(0);
  //soundOut.drawWave();
  soundIn.update();
  soundIn.drawFFT();
  //soundIn.drawDerivativeFFT();
  
  


  
  
  
  //println(soundIn.findHighestFreq());
  //soundIn.printHighestFreqs(6);
  //174, 338
  //232, 280
  
  /*
  leftButton.update();
  leftButton.drawCircle(900, 50);
  rightButton.update();
  rightButton.drawCircle(900, 150);
  
  if (rightButton.hasChanged()) rightCount++;
  if (leftButton.hasChanged()) leftCount++;
  
  */
  text("FPS: " + frameRate, 10,20);
  text(rotary.a.opened + " - " + rotary.a.closed, 10, 35);
  text(rotary.b.opened + " - " + rotary.b.closed, 10, 50);
  
  text(rotary.a.getAverage(), 10, 65);
  
    
  
  rotary.update();
  //rotary.drawStates(900, 50, 900, 150);
  rotary.a.drawAbsoluteThreshold(900,50,0.1f);
  rotary.b.drawAbsoluteThreshold(900,150,0.1f);
  rotary.a.drawHistogram();
  rotary.a.drawDerivativeHistogram();
  
  rotary.a.drawDerivateThreshold(800,50,0.1f);
  rotary.b.drawDerivateThreshold(800,150,0.1f);
  
  
  
  rotary.drawKnob();
  
  
  //button.update();
  //button.drawCircle(600, 150);
  
  /*
  println(rotary.a.closed + " - " + rotary.a.opened
          + " || " +
          rotary.b.closed + " - " + rotary.b.opened);
  */
  
  
  //soundIn.printHighestFreqs(8);

}
  
  
