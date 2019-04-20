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


PImage starFieldImage;
PImage yellowSun;
PImage brightSun;
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

int saveFrameNum = 0;

LEDStrip[][] ledStrips;

// float[][] sunSideMagfield;
// float[][] testFaces;
// PVector testShapePos;
//
// float[][] supernovaVerts;
// float[][] supernovaFaces;
// PVector supernovaShapePos;

float[][] cme;
PVector cmePos;

boolean saveFrames = false;
void settings(){
  fullScreen(P3D, 1);
}

void setup() {

  cam = new PeasyCam(this, 250);
  cam.setSuppressRollRotationMode();

  strokeWeight(4);
  noCursor();

  // sunSideMagfield = getObjArray("halfMagField.obj", "v ", " ", "/");
  // darkSideMagField = getObjArray("halfMagField.obj", "v ", " ", "/");
  // darkSideMagField = getObjArray("halfMagField.obj", "v ", " ", "/");
  cme = getObjArray("magField.obj", "v ", " ", "/");

  // testFaces = getObjArray("rock.obj", "f ", " ", "/");

  starFieldImage = loadImage(dataDir + "starField.png");
  yellowSun     = loadImage(dataDir + "yellowSun.png");
  brightSun     = loadImage(dataDir + "brightSun.png");
  sun           = loadImage(dataDir + "sun.png");
  earth           = loadImage(dataDir + "earth.png");


  ledStrips = new LEDStrip[numStripsHeight][numStripsDepth];
  for (int z = 0; z < numStripsDepth; z++) {
    for (int y = 0; y < numStripsHeight; y++) {
      ledStrips[y][z] = new LEDStrip(y, z);
    }
  }


}

float mfScale1 = 0.0;
float mfScale2 = 0.25;
float mfScale3 = 0.50;
float mfScale4 = 0.75;

float scaleIncrease = 0.001;

void draw() {

  translate(-((xDistBetween-1)*numLedPerStrip)*0.5, -((yDistBetween-1)*numStripsHeight)*0.5, -((zDistBetween-1)*numStripsDepth)*0.5);
  background(0);

  // drawGrowingSphere();

  ///////////// DRAW MAG FIELDS ///////////////
  drawObjectOnCube(cme, mfScale1);
  drawObjectOnCube(cme, mfScale2);
  drawObjectOnCube(cme, mfScale3);
  drawObjectOnCube(cme, mfScale4);


  mfScale1 += scaleIncrease;
  mfScale2 += scaleIncrease;
  mfScale3 += scaleIncrease;
  mfScale4 += scaleIncrease;


  if (mfScale1 > 1){
    mfScale1 = 0.1;
  }
  if (mfScale2 > 1){
    mfScale2 = 0.1;
  }
  if (mfScale3 > 1){
    mfScale3 = 0.1;
  }
  if (mfScale4 > 1){
    mfScale4 = 0.1;
  }

  // if (mfScale < 0.40 || mfScale > 0.60){
  //   // mfScale = 0.0;
  //   scaleIncrease *= -1;
  // }

  for (int z = 0; z < numStripsDepth; z++) {
    for (int y = 0; y < numStripsHeight; y++) {
      for (int x = 0; x < numLedPerStrip; x++){

        if(ledStrips[y][z].leds[x].onVertex){
          // ledStrips[y][z].leds[x].thisColor = color(colorImage.get(ledStrips[y][z].leds[x].colorImagePos, 1));
          // ledStrips[y][z].leds[x].iterateImagePos();
          if (y > numStripsHeight/2){
            ledStrips[y][z].leds[x].thisColor = color(0, 0, 255);
          }
          else{
            ledStrips[y][z].leds[x].thisColor = color(255, 0, 0);
          }
        }
        //// THIS IS GOING TO BREAK WITH MULTIPLE OBJECTS
        else {
          ledStrips[y][z].leds[x].thisColor = color(0);
        }
        if (dist(x,y,z, (numLedPerStrip-1)*0.5, (numStripsHeight-1)*0.5, (numStripsDepth-1)*0.5) < 4){
          ledStrips[y][z].leds[x].thisColor = color(earth.get(ledStrips[y][z].leds[x].colorImagePos, 1));
          ledStrips[y][z].leds[x].iterateImagePos();
          // ledStrips[y][z].leds[x].thisColor = color(252, 184, 19);
        }
        ledStrips[y][z].leds[x].onVertex = false;

      }
    }
  }
  //////////////////////////////////

  for (int z = 0; z < numStripsDepth; z++) {
    for (int y = 0; y < numStripsHeight; y++) {
      ledStrips[y][z].display();
    }
  }
  if (saveFrames){
    saveFrame("../savedFiles/" + str(saveFrameNum) + ".png");
    saveFrameNum += 1;
  }
}

void keyPressed() {
  if (key == 's')
  {
    saveFrames = !saveFrames;
  }
}

void drawObjectOnCube(float[][] objVertsName, float scale){
  for (int v = 0; v < objVertsName.length-1; v++){
    //start at center
    int thisX = Math.round(numLedPerStrip/2+(objVertsName[v][0])*scale);
    int thisY = Math.round(numLedPerStrip/2+(objVertsName[v][1])*scale);
    int thisZ = Math.round(numLedPerStrip/2+(objVertsName[v][2])*scale);
    // stroke(255, 0, 0);
    // print(thisX, " ", thisY, " ", thisZ, " ");
    if (thisX <= 15 && thisY <= 15 && thisZ <= 15 && thisX >= 0 && thisY >= 0 && thisZ >= 0){
      ledStrips[thisX][thisY].leds[thisZ].onVertex = true;
    }
  }
}



void drawGrowingSphere(){

  color thisColor;

  for (int z = 0; z < numStripsDepth; z++) {
    for (int y = 0; y < numStripsHeight; y++) {
      for (int x = 0; x < numLedPerStrip; x++){
        // ledStrips[y][z].getColor(x);
        // ledStrips[y][z].updateColor(x, color(random(255), random(255), random(255)));
        if (dist(x,y,z, (numLedPerStrip-1)*0.5, (numStripsHeight-1)*0.5, (numStripsDepth-1)*0.5) < sizeSphere){
          thisColor = color(brightSun.get(ledStrips[y][z].leds[x].colorImagePos, 1));
          ledStrips[y][z].leds[x].iterateImagePos();
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
