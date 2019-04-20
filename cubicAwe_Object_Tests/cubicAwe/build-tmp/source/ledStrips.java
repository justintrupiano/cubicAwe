import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import peasy.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class ledStrips extends PApplet {



String dataDir    = "../../data/";

int canvasW = 500;
int canvasH = 500;

float[][] square  = new float[0][0];

int numStripsWidth  = 16;
int numLedPerStrip  = 16;
int numStripsDepth  = 16;

int xDistBetween  = 20;
int yDistBetween  = 20;
int zDistBetween  = 20;

PImage starFieldImage;
PImage sun;
PImage mercury;
PImage venus;
PImage earth;
PImage mars;
PImage jupiter;
PImage saturn;
PImage uranus;
PImage neptune;

PShape objSquare; 

LEDStrip[][] ledStrips;

PeasyCam cam;



public void settings(){
  fullScreen(P3D);

}


public void setup() {
  // size(100, 100);
  // objSquare = new PShape();
  // objSquare = loadshape(dataDir + "test.obj");
  square = getObjArray("test.obj");
  for (int x = 0; x < square.length; x++){
    for (int y = 0; y < square[x].length; y++){
        print(square[x][y], " ");
    }

  }
  // cam = new PeasyCam(this, xDistBetween*numStripsWidth/2, xDistBetween*numLedPerStrip/2, xDistBetween*numStripsDepth/2, 10);
  cam = new PeasyCam(this, 500, 0, 0, 100);
  // cam = new PeasyCam(this, xDistBetween*numStripsWidth, 0, 0, 100);
  cam.setYawRotationMode();   
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(500);

  strokeWeight(2);
  noCursor();
  frameRate(5);

  starFieldImage = loadImage(dataDir + "starField.png");

  sun = loadImage(dataDir + "sun.png");
  mercury = loadImage(dataDir + "mercury.png");
  venus = loadImage(dataDir + "venus.png");
  earth = loadImage(dataDir + "earth.png");
  mars = loadImage(dataDir + "mars.png");
  jupiter = loadImage(dataDir + "jupiter.png");
  saturn = loadImage(dataDir + "saturn.png");
  uranus = loadImage(dataDir + "uranus.png");
  neptune = loadImage(dataDir + "neptune.png");

  ledStrips = new LEDStrip[numStripsWidth][numStripsDepth];
  for (int z = 0; z < numStripsDepth; z++) {
    for (int x = 0; x < numStripsWidth; x++) {
      ledStrips[x][z] = new LEDStrip();
    }
  }
}


public void draw() {
  // translate(width/2,height/2, 0);
  background(0);
  // shape(objSquare);
  for (int z = 0; z < numStripsDepth; z++) {
    for (int x = 0; x < numStripsWidth; x++) {
      ledStrips[x][z].drawSolarSystem(x, z);
    }
  }
}



public float[][] getObjArray(String objFileName){
  
  String[]    objFile       = loadStrings(dataDir + objFileName);
  String[]    stringArray   = new String[0];

  for (int i =0; i < objFile.length; i++){
    if (objFile[i].substring(0, 2).equals("v ")) {
      stringArray = append(stringArray, objFile[i].substring(2));
    }
  }
  
  float[][] objArray = new float[stringArray.length][0];

  for (int i = 0; i < stringArray.length; i++) {
    String[]  thisString  = split(stringArray[i], " ");
    float[]   thisArray   = new float[0];
    
    for (int j = 0; j < thisString.length; j++) {
        objArray[i] = append(objArray[i], PApplet.parseFloat(thisString[j]));
    }
  }

  return objArray;
}

class LEDStrip {
	int[] ledColor = new int[numLedPerStrip];
	int[] imagePos = new int[numLedPerStrip];

	LEDStrip (){ //Should take array of colors

		for (int i = 0; i < numLedPerStrip; i++){
			imagePos[i] = PApplet.parseInt(random(1999));
		}
	}

	public void starField(){
		float speed = 1;

		for(int y = 0; y < ledColor.length; y++){

			if (imagePos[y] >= 1999){
				imagePos[y] = 0;
			}
			else{
				imagePos[y] += speed;
			}
			ledColor[y] = color(starFieldImage.get(imagePos[y], 1));
		}
	}

	public void drawPlanet(PImage planet, int distance, int planetSize, int x, int y, int z){
		if(dist(x, y, z, 8, 8, distance) < planetSize){ // SUN
			stroke(color(planet.get(PApplet.parseInt(random(2000)), 1)));
		}

	}


	public void drawSolarSystem(int x, int z){
		float speed = 5;


		for(int y = 0; y < numLedPerStrip; y++){
			
			if(dist(x, y, z, numStripsWidth/2, numLedPerStrip/2, numStripsDepth/2) < 7){ 
			// if(dist(x, y, z, 0,numLedPerStrip/2,-48) < 50){ // SUN
				stroke(color(sun.get(PApplet.parseInt(random(2000)), 1)+10));

			}

			else if( // HIGHLIGHT EDGES //
				(x == 0				   && z == 0) 				 ||
				(x == 0 			   && z == numStripsDepth-1) ||
				(x == numStripsWidth-1 && z == 0) 				 ||
				(x == numStripsWidth-1 && z == numStripsDepth-1) ||

				(x == 0				   && y == 0) 				 ||
				(x == 0				   && y == numLedPerStrip-1) ||
				(x == numStripsWidth-1 && y == 0)				 ||
				(x == numStripsWidth-1 && y == numLedPerStrip-1) ||

				(z == 0 			   && y == 0) 				 ||
				(z == 0 			   && y == numLedPerStrip-1) ||
				(z == numStripsDepth-1 && y == 0) 				 ||
				(z == numStripsDepth-1 && y == numLedPerStrip-1)

				)
				{ stroke(255); }


			else{
				if (imagePos[y] >= 1999){
					imagePos[y] = 0;
				}
				else{
					imagePos[y] += speed;
				}

				ledColor[y] = color(starFieldImage.get(imagePos[y], 1));

	  			stroke((ledColor[y]), 100);
  			// stroke(255);

			}

			// stroke(255);

		point(x*xDistBetween, (y*yDistBetween)-(numLedPerStrip*yDistBetween)/2, (-z*zDistBetween));



      	}


	}

	public void display(int x, int z){
		// starField();

		float speed = 5;


		for(int y = 0; y < numLedPerStrip; y++){

			if (imagePos[y] >= 1999){
				imagePos[y] = 0;
			}
			else{
				imagePos[y] += speed;
			}
			ledColor[y] = color(starFieldImage.get(imagePos[y], 1));
		
			// print(ledColor[y]);
			// stroke(255);

			if(dist(x, y, z, 8, 8, -48) < 50){ // SUN
				stroke(255, 127, 127);

      		}
			// if(x == 8 && y == 8 && z == 20 ){
			// 	stroke(255, 0, 0);
   //    		}


      		else{
      			stroke(ledColor[y]);
      			// stroke(255);
      		}

			point(x*xDistBetween, (y*yDistBetween)-(numLedPerStrip*yDistBetween)/2, (-z*zDistBetween));
		}


	}


}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "ledStrips" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
