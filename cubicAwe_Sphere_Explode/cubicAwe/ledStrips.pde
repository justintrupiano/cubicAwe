class singleLED {
	color thisColor;
	int 	colorImagePos;

	singleLED (){
		thisColor 		= color(0);
		colorImagePos = int(random(imageSize));
	}

	void iterateImagePos(int iterateSpeed){
		if (colorImagePos >= imageSize-iterateSpeed){
			colorImagePos = 0;
		}
		else{
			colorImagePos += iterateSpeed;
		}
	}
}



class LEDStrip {
	singleLED[] leds;
	PVector 		stripPos;

	LEDStrip (int y, int z){
		leds 			= new singleLED[numLedPerStrip];
		stripPos 	= new PVector(0, y, z);

		for (int x = 0; x < numLedPerStrip; x++){
			leds[x] = new singleLED();
			leds[x].thisColor = color(0);
		}
	}

	void display(){
		for (int x = 0; x < numLedPerStrip; x++){
			stroke(leds[x].thisColor);
			point(x*xDistBetween, stripPos.y*yDistBetween, stripPos.z*zDistBetween);
		}
	}
}
