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

int saveFrameNum = 0;

LEDStrip[][] ledStrips;

/// DECLARE OBJECT ARRAYS HERE: float[][] testObj; AND: PVector currentPos;
/// I SHOULD MAKE THESE OBJECTS...

float[][] magnet;
PVector magnetPos = new PVector(8,8,8);

float[][] magField;
PVector magFieldPos;

float[][] cme;
PVector cmePos = new PVector(7.5,7.5,7.5);
PVector cmsScale = new PVector(8,8,8);

boolean saveFrames = false;
boolean showNums = false;

void settings(){
  fullScreen(P3D, 1);
}

void setup() {
  cam = new PeasyCam(this, 250);
  cam.setSuppressRollRotationMode();

  strokeWeight(4);
  noCursor();
  // magField = getObjArray("magField.obj", "v ", " ", "/");
  // magnet = getObjArray("magenet.obj", "v ", " ", "//");
  cme = getObjArray("everest.obj", "v ", " ", "//");

  // testFaces = getObjArray("rock.obj", "f ", " ", "/");

  starFieldImage =  loadImage(dataDir + "starField.png");
  yellowSun     =   loadImage(dataDir + "yellowSun.png");
  brightSun     =   loadImage(dataDir + "brightSun.png");
  sun           =   loadImage(dataDir + "sun.png");

  rotateZ3D(cme, -PI/2);

  ledStrips = new LEDStrip[numStripsHeight][numStripsDepth];
  for (int z = 0; z < numStripsDepth; z++) {
    for (int y = 0; y < numStripsHeight; y++) {
      ledStrips[y][z] = new LEDStrip(y, z);
    }
  }
}

// float mfScale1 = 0.0;
// float mfScale2 = 0.25;
// float mfScale3 = 0.50;
// float mfScale4 = 0.75;

// float scaleIncrease = 0.001;


float rotateAngle = 0.01;
// PVector increaseScale = new PVector(0.01,0.01,0.01);


void draw() {
  background(0);
  // cmsScale.add(increaseScale);
  translate(-((xDistBetween-1)*numLedPerStrip)*0.5, -((yDistBetween-1)*numStripsHeight)*0.5, -((zDistBetween-1)*numStripsDepth)*0.5);
  // rotateAngle += 0.001;
  // drawSphere(50, 15,new PVector(-48,7.5,7.5));

  // magnetPos.rotate(rotateAngle);
  // drawGrowingSphere();
  // rotateX3D(magnet, 0.01);
  // rotateZ3D(cme, 0.01);

  if (cmePos.z > 60){cmePos.z = -10;}

  // moveObject(cmePos, new PVector(0.0, 0.0, 0.1));
  drawObjectOnCube(cme, cmsScale, cmePos);

  for (int x = 0; x < numStripsDepth; x++) {
    for (int y = 0; y < numStripsHeight; y++) {
      for (int z = 0; z < numLedPerStrip; z++){

        if(showNums){
          text("(" +str(x) + ", "+ str(y) +", " + str(z) + ") ", x * xDistBetween, y* yDistBetween, z * zDistBetween);
        }

        if(ledStrips[y][x].leds[z].ledOn){
          ledStrips[y][x].leds[z].thisColor = color(sun.get(ledStrips[y][x].leds[z].colorImagePos, 1));
          ledStrips[y][x].leds[z].iterateImagePos();
          // if (y > numStripsHeight/2){
          //   ledStrips[y][z].leds[x].thisColor = color(0, 0, 255);
          // }
          // else{
          //   ledStrips[y][z].leds[x].thisColor = color(255, 0, 0);
          // }
        }
        //// THIS IS GOING TO BREAK WITH MULTIPLE OBJECTS
        else {
          ledStrips[y][x].leds[z].thisColor = color(25);
        }
        // if (dist(x,y,z, (numLedPerStrip-1)*0.5, (numStripsHeight-1)*0.5, (numStripsDepth-1)*0.5) < 4){
        //   ledStrips[y][z].leds[x].thisColor = color(sun.get(ledStrips[y][z].leds[x].colorImagePos, 1));
        //   ledStrips[y][z].leds[x].iterateImagePos();
        //   // ledStrips[y][z].leds[x].thisColor = color(252, 184, 19);
        // }
        ledStrips[y][x].leds[z].ledOn = false;

      }
    }
  }  // drawObjectOnCube FUNCTION JUST MARKS LEDS AS ON... COLOR IS GIVEN LATER

  //////////////////////////////////

  for (int x = 0; x < numStripsDepth; x++) {
    for (int y = 0; y < numStripsHeight; y++) {
      ledStrips[y][x].display();
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
  if(key == 'n'){
    showNums = !showNums;
  }
}

void moveObject(PVector objPos, PVector direction){
    objPos.x += direction.x;
    objPos.y += direction.y;
    objPos.z += direction.z;
}

void rotateZ3D(float[][] objVerts, float theta) {
  float sin_t = sin(theta);
  float cos_t = cos(theta);

    for (int v = 0; v < objVerts.length-1; v++) {
      float x = objVerts[v][0];
      float z = objVerts[v][2];

      objVerts[v][0] = x * cos_t - z * sin_t;
      objVerts[v][2] = z * cos_t + x * sin_t;
    }
};

void rotateX3D(float[][] objVerts, float theta) {
    float sin_t = sin(theta);
    float cos_t = cos(theta);

    for (int v = 0; v < objVerts.length-1; v++) {
        float y = objVerts[v][1];
        float z = objVerts[v][2];
        objVerts[v][1] = y * cos_t - z * sin_t;
        objVerts[v][2] = z * cos_t + y * sin_t;
    }
};



void drawObjectOnCube(float[][] objVertsName, PVector scale, PVector currentPos){
  // drawObjectOnCube FUNCTION JUST MARKS LEDS AS ON... COLOR IS GIVEN LATER
  for (int v = 0; v < objVertsName.length-1; v++){

    int thisX = Math.round(currentPos.x   + (objVertsName[v][0])*scale.x);
    int thisY = Math.round(currentPos.y   + (objVertsName[v][1])*scale.y);
    int thisZ = Math.round(currentPos.z   + (objVertsName[v][2])*scale.z);

    if (thisX <= 15 && thisY <= 15 && thisZ <= 15 && thisX >= 0 && thisY >= 0 && thisZ >= 0){
      ledStrips[thisX][thisY].leds[thisZ].ledOn = true;
    }
  }
}


void drawSphere(float size, int iterate, PVector center){
  for (int x = 0; x < numStripsDepth; x++) {
    for (int y = 0; y < numStripsHeight; y++) {
      for (int z = 0; z < numLedPerStrip; z++){
        if (dist(x,y,z, center.x,center.y,center.z) < size){
          ledStrips[y][z].leds[x].ledOn = true;
          ledStrips[y][z].leds[x].iterateSpeed = iterate;
          ledStrips[y][z].leds[x].iterateImagePos();
        }
      }
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
          ledStrips[y][z].leds[x].iterateSpeed = 5;
          ledStrips[y][z].leds[x].iterateImagePos();
        }
        else{
          thisColor = color(25);
        }
        ledStrips[y][z].leds[x].thisColor = thisColor;
      }
    }
  }

  if (sizeSphere > 15 || sizeSphere < 0) {increment *= -1;}
  sizeSphere += increment;

}
