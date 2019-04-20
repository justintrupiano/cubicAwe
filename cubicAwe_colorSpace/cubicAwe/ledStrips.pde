class singleLED {
	color 	thisColor;
	int 		colorImagePos = int(random(imageSize));
	int 		iterateSpeed = 2;
	boolean ledOn = true;


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
		for (int x = 0; x < numLedPerStrip; x++){
			stroke(leds[x].thisColor);
			point(x*xDistBetween, stripPos.y*yDistBetween, stripPos.z*zDistBetween);
		}
	}
}
