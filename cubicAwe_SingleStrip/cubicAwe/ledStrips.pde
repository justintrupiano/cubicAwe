class singleLED {
	color thisColor;
	int 	colorImagePos;

	singleLED (int x, int y, int z){
		thisColor 		= color(0);
		x = x;
		y = y;
		z = z;
		colorImagePos = int(random(imageSize));


	}

	void iterateImagePos(int iterateSpeed){
		if (colorImagePos >= imageSize-iterateSpeed){
			colorImagePos = (colorImagePos-imageSize) + iterateSpeed;
		}
		else{
			colorImagePos += iterateSpeed;
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
			leds[z] = new singleLED(x, y, z);
			leds[z].thisColor = color(25);
		}
	}

	void display(){
		for (int x = 0; x < numLedPerStrip; x++){
			stroke(leds[x].thisColor);
			point(x*xDistBetween, stripPos.y*yDistBetween, stripPos.z*zDistBetween);
		}
	}
}

// class auroraLED extends singleLED{
//
// }
