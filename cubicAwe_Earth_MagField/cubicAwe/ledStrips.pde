class singleLED {
	color 	thisColor;
	int 		colorImagePos;
	int 		iterateSpeed = 1;
	boolean ledOn = false;
	boolean onCMEStuff = false;

	singleLED (){
		thisColor 		= color(25);
		colorImagePos = int(random(imageSize));
	}

	void iterateImagePos(){
		if (colorImagePos >= imageSize-iterateSpeed){
			colorImagePos 	= 0;
		}
		else{
			colorImagePos 	+= iterateSpeed;
		}
	}
}

class LEDStrip {
	singleLED[] leds;
	PVector 		stripPos;

	LEDStrip (int x, int y){
		leds 			= new singleLED[numLedPerStrip];
		stripPos 	= new PVector(0, x, y);

		for (int z = 0; z < numLedPerStrip; z++){
			leds[z] = new singleLED();
		}
	}

	void display(){
		for (int i = 0; i < numLedPerStrip; i++){
			stroke(leds[i].thisColor);
			point(i*xDistBetween, stripPos.y*yDistBetween, stripPos.z*zDistBetween);
			if(showNums){
			  text("(" + str(i) + ", " + str(stripPos.y) + ", " + str(stripPos.z) + ") ",
								i*xDistBetween, stripPos.y*yDistBetween, stripPos.z*zDistBetween);
			}
		}
	}
}




class CMEStuff {
  PVector cmeStuffPos;

	CMEStuff (){
  int y = (random(1)>0.5) ? int(random(0, numStripsHeight*0.25)) : int(random(numStripsHeight*0.75, numStripsHeight));
    cmeStuffPos = new PVector(int(random(numStripsDepth)), y, int(random(numLedPerStrip)));
	}

	void move(float speed){
		if (cmeStuffPos.z > numLedPerStrip){
			int y = (random(1)>0.5) ? int(random(0, numStripsHeight*0.25)) : int(random(numStripsHeight*0.75, numStripsHeight));

			cmeStuffPos = new PVector(int(random(numStripsDepth)), y, 0);
		}
    cmeStuffPos.add(0, 0, speed);
  }

}
