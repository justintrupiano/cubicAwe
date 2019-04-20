import peasy.*;
PeasyCam cam;

String dataDir    = "../../data/";

int canvasW = 1920;
int canvasH = 1080;

float[][] cube  = new float[0][0];
float sizeSphere = 1;
float increment = 0.1;

int imageSize         = 4000;
int numStripsHeight  	= 16;
int numLedPerStrip  	= 16;
int numStripsDepth  	= 16;

int xDistBetween  		= 100;
int yDistBetween  		= 100;
int zDistBetween  		= 100;

float scale 			    = 0.75;

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

float[][] testVerts;
float[][] testFaces;
PVector testShapePos;

float[][] supernovaVerts;
float[][] supernovaFaces;
PVector supernovaShapePos;


void settings(){
  fullScreen(P3D, 1);
  // size(canvasW, canvasH);
}



void setup() {
  // frameRate(5);
  cam = new PeasyCam(this, 500);
  cam.setSuppressRollRotationMode();  // Permit pitch/yaw only.

  strokeWeight(4);
  noCursor();

  starFieldImage = loadImage(dataDir + "starField.png");

  sun     = loadImage(dataDir + "sun.png");
  mercury = loadImage(dataDir + "mercury.png");
  venus   = loadImage(dataDir + "venus.png");
  earth   = loadImage(dataDir + "earth.png");
  mars    = loadImage(dataDir + "mars.png");
  jupiter = loadImage(dataDir + "jupiter.png");
  saturn  = loadImage(dataDir + "saturn.png");
  uranus  = loadImage(dataDir + "uranus.png");
  neptune = loadImage(dataDir + "neptune.png");

  ledStrips = new LEDStrip[numStripsHeight][numStripsDepth];
  for (int z = 0; z < numStripsDepth; z++) {
    for (int y = 0; y < numStripsHeight; y++) {
      ledStrips[y][z] = new LEDStrip(y, z);
    }
  }

}


String[] testing = new String[0];

void draw() {

  translate(-((xDistBetween-1)*numLedPerStrip)*0.5, -((yDistBetween-1)*numStripsHeight)*0.5, -((zDistBetween-1)*numStripsDepth)*0.5);
  background(0);

  //// DRAW OBJ ON LEDS ////
  // for (int v = 0; v < testVerts.length-1; v++){
  //
  // 	//start at center
  // 	int thisX = Math.round(numLedPerStrip/2+(testVerts[v][0])*scale);
  // 	int thisY = Math.round(numLedPerStrip/2+(testVerts[v][1])*scale);
  // 	int thisZ = Math.round(numLedPerStrip/2+(testVerts[v][2])*scale);
  // 	// stroke(255, 0, 0);
  // 	// print(thisX, " ", thisY, " ", thisZ, " ");
  // 	ledStrips[thisY][thisZ].updateColor(thisX, color(255, 0, 255));
  // 	// point(thisX, thisY, thisZ);
  // }
  ////////////////////

  drawGrowingSphere();
  // for (int z = 0; z < numStripsDepth; z++) {
  //   for (int y = 0; y < numStripsHeight; y++) {
  //     for (int x = 0; x < numLedPerStrip; x++){
  //       testing = append(testing, str(ledStrips[y][z].leds[x].thisColor));
  //       print(testing);
  //     }
  //   }
  // }

  testing = new String[0];
  for (int z = 0; z < numStripsDepth; z++) {
    for (int y = 0; y < numStripsHeight; y++) {

      for (int x = 0; x < numLedPerStrip; x++){
        color c = ledStrips[y][z].leds[x].thisColor;
        // print(, " ");
        testing = append(testing, hex(c, 6));
        // ledStrips[y][z].getColor(x);
        // ledStrips[y][z].updateColor(x, color(random(255), random(255), random(255)));
      }
      ledStrips[y][z].display();
    }
  }

  // // SAVING FILES //
  // // BASH SCRIPT: for i in *;do cat "$i" | tr -d "\n" >> outputFile.txt; done
  // saveStrings( "./frames/" + nf(frameCount, 5) + ".txt", testing);
  // if(frameCount == 279){exit();}
  //
  // /////////////////
}


void drawGrowingSphere(){

  color thisColor;

  for (int z = 0; z < numStripsDepth; z++) {
    for (int y = 0; y < numStripsHeight; y++) {
      for (int x = 0; x < numLedPerStrip; x++){
        // ledStrips[y][z].getColor(x);
        // ledStrips[y][z].updateColor(x, color(random(255), random(255), random(255)));
        if (dist(x,y,z, (numLedPerStrip-1)*0.5, (numStripsHeight-1)*0.5, (numStripsDepth-1)*0.5) < sizeSphere){
          thisColor = color(sun.get(ledStrips[y][z].leds[x].colorImagePos, 1));
          ledStrips[y][z].leds[x].iterateImagePos(10);

        }
        else{
          thisColor = color(0);
        }
        ledStrips[y][z].leds[x].thisColor = thisColor;
      }
    }
  }

  if (sizeSphere > 15 || sizeSphere < 0) {increment *= -1;}
  sizeSphere += increment;

}
