import peasy.*;
PeasyCam cam;

String dataDir    = "../../data/";

int canvasW = 1920;
int canvasH = 1080;

float[][] cube  = new float[0][0];
float sizeSphere = 1;
float increment = 0.1;
float noiseScale = 5;


int imageSize         = 4000;
int numStripsHeight  	= 16;
int numLedPerStrip  	= 16;
int numStripsDepth  	= 16;

int xDistBetween  		= 100;
int yDistBetween  		= 100;
int zDistBetween  		= 100;

PImage sun;
PImage earth;
PImage aurora;

int saveFrameNum = 0;
int maxScale = 19;

LEDStrip[][] ledStrips;
float[][] auroraObject;

PVector auroraObjectPos1       = new PVector(7.5,7.5,numLedPerStrip);
PVector auroraObjectPos2       = new PVector(7.5,7.5,-120);
PVector auroraScale    = new PVector(1,2,1);



boolean saveFrames = false;
boolean showNums = false;

void settings(){
  fullScreen(P3D, 1);
}

void setup() {
  cam = new PeasyCam(this, 2000);
  // cam.setSuppressRollRotationMode();
  cam.setYawRotationMode();
  // cam.rotateY(PI*0.5);

  strokeWeight(6);
  noCursor();


  aurora          =   loadImage(dataDir + "auroraSmooth.png");
  auroraObject  = getObjArray("auroraObject.obj", "v ", " ", "//");

  // backSidePos.rotate(HALF_PI);


  ledStrips = new LEDStrip[numStripsHeight][numStripsDepth];
  for (int x = 0; x < numStripsHeight; x++) {
    for (int y = 0; y < numStripsDepth; y++) {
      ledStrips[x][y] = new LEDStrip(x, y);
    }
  }
}

PVector auroraIncrease = new PVector(0.00, 0.00, 0.075);


double camRotate = 0.0025;
// double camRotate = 0.0;
double camCurrent = camRotate;

void draw() {
  background(0);

  camCurrent += camRotate;
  cam.rotateY(camRotate);

  translate(-((xDistBetween)*(numStripsHeight-1))/2, -((yDistBetween)*numStripsDepth)/2, -((zDistBetween)*(numLedPerStrip-1))/2);


  // if (backSideScale2.z > 0){ backSideScale2 = new PVector(-maxScale, -maxScale, -maxScale);}
  auroraObjectPos1.add(auroraIncrease);
  auroraObjectPos2.add(auroraIncrease);


  drawObjectOnCube(auroraObject, auroraScale, auroraObjectPos1);
  drawObjectOnCube(auroraObject, auroraScale, auroraObjectPos2);

  for (int x = 0; x < numStripsHeight; x++) {
    for (int y = 0; y < numStripsDepth; y++) {
      for (int z = 0; z < numLedPerStrip; z++){

        // ledStrips[x][round(y+noise(noiseScale))].leds[z].ledOn = true;

        if(!ledStrips[x][y].leds[z].ledOn){
          ledStrips[x][y].leds[z].thisColor = color(25);
        }

        if(ledStrips[x][y].leds[z].ledOn){
          ledStrips[x][y].leds[z].thisColor = color(aurora.get(ledStrips[x][y].leds[z].colorImagePos, 1));
          ledStrips[x][y].leds[z].iterateImagePos();
        }


        ///////////////// HIGHLIGHT CORNER ///////////////
        // ledStrips[0][0].leds[0].thisColor                                   = color(255);
        ///////////////// HIGHLIGHT CORNER ///////////////

        ledStrips[x][y].leds[z].ledOn = false;

      }
    }
  }





  // drawSphere(3, 1, new PVector (7.5,7.5,7.5));

  //////////////////////////////////

  for (int x = 0; x < numStripsDepth; x++) {
    for (int y = 0; y < numStripsHeight; y++) {
      ledStrips[x][y].display();
    }
  }

  if (saveFrames){
    saveFrame("../savedFiles/" + str(saveFrameNum) + ".png");
    saveFrameNum += 1;
  }
  if (camCurrent > TWO_PI ){exit();}



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

  // numStripsHeight
  // numLedPerStrip
  // numStripsDepth
  for (int v = 0; v < objVertsName.length-1; v++){

    int thisX = Math.round(currentPos.x   + (objVertsName[v][0])*scale.x);
    int thisY = Math.round(currentPos.y   + (objVertsName[v][1])*scale.y);
    int thisZ = Math.round(currentPos.z   + (objVertsName[v][2])*scale.z);

    if (thisX < numStripsHeight && thisY < numStripsDepth && thisZ < numLedPerStrip && thisX >= 0 && thisY >= 0 && thisZ >= 0){
      ledStrips[thisY][thisX].leds[thisZ].ledOn = true;


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


void drawGrowingSphere(PImage image){

  color thisColor;

  for (int z = 0; z < numStripsDepth; z++) {
    for (int y = 0; y < numStripsHeight; y++) {
      for (int x = 0; x < numLedPerStrip; x++){
        //
        // int numStripsHeight  	= 16;
        // int numLedPerStrip  	= 16;
        // int numStripsDepth  	= 16;
        // ledStrips[y][z].getColor(x);
        // ledStrips[y][z].updateColor(x, color(random(255), random(255), random(255)));
        if (dist(x,y,z, (numLedPerStrip-1)*0.5, (numStripsHeight-1)*0.5, (numStripsDepth-1)*0.5) < sizeSphere){
          thisColor = color(image.get(ledStrips[y][z].leds[x].colorImagePos, 1));
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
