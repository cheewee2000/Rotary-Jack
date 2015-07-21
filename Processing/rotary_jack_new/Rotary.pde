class Rotary
{ 
  int rotaryValue;
  int lastRotarySignal;
  
  int aCount;
  int bCount;
  
  Button a;
  Button b;
  
  Rotary(int aFreq1, int aFreq2, int bFreq1, int bFreq2, float thresholda, float thresholdb)
  {
    rotaryValue = 0;
    lastRotarySignal = 0; 
    
    aCount = 0;
    bCount = 0;
    
    a = new Button(aFreq1, aFreq2, thresholda);
    b = new Button(bFreq1, bFreq2, thresholdb);
  }
  
  void update()
  {
    a.update();
    b.update();
    
    rotaryValue += checkMovement();
  }
  
  void drawStates(int aX, int aY, int bX, int bY)
  {
    a.drawCircle(aX, aY);
    b.drawCircle(bX, bY);
  }
  
  void drawKnob()
  {
    pushStyle();
    noFill();
    stroke(255);
    
    pushMatrix();
    translate(850, 300);
    ellipse(0, 0, 150, 150);
    textSize(32);
    text(rotaryValue, -150, 0);

    rotate( 2*PI /100 * rotaryValue);
    line(0,0, 0, -75);
    rotate(PI/2);
    textSize(10);
    text(rotaryValue, -100, 0);  
    popMatrix();  
    popStyle();
  }
  
  
  int checkMovement()
  {     
    int rotarySignal = 0;
    
    if (!a.hasChanged & !b.hasChanged) return 0;
    
    //println(int(a.isClosed()) + "" + int(b.isClosed()));

    
    if( !a.hasChanged() ){
      //aCount++;
      if ( a.isClosed() ){
       rotarySignal = 2;
       aCount++;
      }
    }
    
    if ( !b.hasChanged() ){
      if ( b.isClosed() ){
       rotarySignal = 1;
       bCount++;
      }
    }

    
    /*    
    if( a.isClosed() && b.isClosed()){
      rotarySignal = 3;
    } else 
    */
    
    if ( a.isClosed() ){
      rotarySignal = 2;
    } else if ( b.isClosed() ){
      rotarySignal = 1;
    } else {
      rotarySignal = 0;
    }    
    
    if ( lastRotarySignal == rotarySignal) return 0;
    
    //println(rotarySignal);
    
    int movement = 0;
    
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
      
      /*
      case 3:
      movement = (lastRotarySignal == 2) ? 1 : -1;
      break;
      */
    }
    
    
    lastRotarySignal = rotarySignal;
    
    return movement;

  }
  
  
  
    
  
}
