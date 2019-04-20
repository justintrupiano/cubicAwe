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
PImage earth;

int saveFrameNum = 0;

LEDStrip[][] ledStrips;

/// DECLARE OBJECT ARRAYS HERE: float[][] testObj; AND: PVector currentPos;
/// I SHOULD MAKE THESE OBJECTS...



int maxScale = 1;

float[][] magField;
PVector magFieldPos       = new PVector(7.5,7.5,7.5);
PVector magFieldScale1    = new PVector(0,0,0);
PVector magFieldScale2    = new PVector(0.33,0.33,0.33);
PVector magFieldScale3    = new PVector(0.66,0.66,0.66);


boolean saveFrames = true;
boolean showNums = false;

void settings(){
  fullScreen(P3D, 1);
}

void setup() {
  cam = new PeasyCam(this, 2000);
  // cam.setSuppressRollRotationMode();
  cam.setYawRotationMode();

  strokeWeight(6);
  noCursor();

  magField = getObjArray("magField.obj", "v ", " ", "//");

  // starFieldImage  =  loadImage(dataDir + "starField.png");
  // yellowSun       =   loadImage(dataDir + "yellowSun.png");
  // brightSun       =   loadImage(dataDir + "brightSun.png");
  sun             =   loadImage(dataDir + "sun.png");
  // earth           =   loadImage(dataDir + "earthImage.png");

  // backSidePos.rotate(HALF_PI);


  ledStrips = new LEDStrip[numStripsHeight][numStripsDepth];
  for (int x = 0; x < numStripsHeight; x++) {
    for (int y = 0; y < numStripsDepth; y++) {
      ledStrips[x][y] = new LEDStrip(x, y);
    }
  }
}

// float rotateAngle = 0.01;
PVector increaseScale = new PVector(0.001, 0.001, 0.001);


double camRotate = 0.005;
double camCurrent = camRotate;

void draw() {
  background(0);

  camCurrent += camRotate;
  cam.rotateY(camRotate);

  translate(-((xDistBetween)*(numStripsHeight-1))/2, -((yDistBetween)*numStripsDepth)/2, -((zDistBetween)*(numLedPerStrip-1))/2);

  if (magFieldScale1.z > maxScale){ magFieldScale1 = new PVector(0,0,0);}
  magFieldScale1.add(increaseScale);
  drawObjectOnCube(magField, magFieldScale1, magFieldPos);

  if (magFieldScale2.z > maxScale){ magFieldScale2 = new PVector(0,0,0);}
  magFieldScale2.add(increaseScale);
  drawObjectOnCube(magField, magFieldScale2, magFieldPos);

  if (magFieldScale3.z > maxScale){ magFieldScale3 = new PVector(0,0,0);}
  magFieldScale3.add(increaseScale);
  drawObjectOnCube(magField, magFieldScale3, magFieldPos);



  for (int x = 0; x < numStripsHeight; x++) {
    for (int y = 0; y < numStripsDepth; y++) {
      for (int z = 0; z < numLedPerStrip; z++){

        // if(showNums){
        //   text("(" +str(x) + ", "+ str(y) +", " + str(z) + ") ", z * zDistBetween, y * yDistBetween, x*xDistBetween);
        // }

        if(!ledStrips[x][y].leds[z].ledOn){
          ledStrips[x][y].leds[z].thisColor = color(25);
        }

        // if(ledStrips[x][y].leds[z].ledOn){
        //   if (y > numStripsHeight/2){
        //     ledStrips[x][y].leds[z].thisColor = color(0, 0, 255);
        //   }
        //   else{
        //     ledStrips[x][y].leds[z].thisColor = color(255, 0, 0);
        //   }
        // }
        //// THIS IS GOING TO BREAK WITH MULTIPLE OBJECTS
        // else {
        //   ledStrips[x][y].leds[z].thisColor = color(25);
        // }

        if(ledStrips[x][y].leds[z].ledOn){

          float centerDist  = dist(x,y,z, (numStripsHeight-1)*0.5, (numStripsDepth-1)*0.5, (numLedPerStrip-1)*0.5);
          float redBright   = map(centerDist, 0, numStripsHeight/2, 255, 0);
          float blueBright  = map(centerDist, 0, numStripsHeight/2, 255, 0);

          if (x > numStripsHeight/2){
            ledStrips[x][y].leds[z].thisColor = color(blueBright, blueBright, 255);
          }
          else{
            ledStrips[x][y].leds[z].thisColor = color(255, redBright, redBright);
          }
        }

        //// FOR SUN
        if (dist(x,y,z, (numStripsHeight-1)*0.5, (numStripsDepth-1)*0.5, (numLedPerStrip-1)*0.5) < 4){
          ledStrips[x][y].leds[z].thisColor = color(sun.get(ledStrips[x][y].leds[z].colorImagePos, 1));
          ledStrips[x][y].leds[z].iterateImagePos();
          // ledStrips[y][z].leds[x].thisColor = color(252, 184, 19);
        }

        // /////////////// HIGHLIGHT CORNERS ///////////////
        // ledStrips[0][0].leds[0].thisColor                                   = color(255,255,255);

        // ledStrips[0][0].leds[0].thisColor                                   = color(0,0,0);
        // ledStrips[0][0].leds[numStripsDepth-1].thisColor                    = color(0,0,255);
        // ledStrips[0][numStripsHeight-1].leds[0].thisColor                   = color(0,255,0);
        // ledStrips[0][numStripsHeight-1].leds[numStripsDepth-1].thisColor    = color(0,255,255);
        // ledStrips[numStripsDepth-1][0].leds[0].thisColor                    = color(255,0,0);
        // ledStrips[numStripsDepth-1][0].leds[numStripsDepth-1].thisColor     = color(255,0,255);
        // ledStrips[numStripsDepth-1][numStripsHeight-1].leds[0].thisColor    = color(255,255,0);
        // ledStrips[numStripsDepth-1][numStripsHeight-1].leds[numStripsDepth-1].thisColor = color(255,255,255);
        // /////////////////////////////////////////////////

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
  if (camCurrent > PI*8.5){exit();}
  // if (frameCount == 1){ saveFrame("../savedFiles/" + str(frameCount) + ".png"); }
  // if (camCurrent > PI*8){ saveFrame("../savedFiles/" + str(frameCount) + ".png"); }
  // if (camCurrent > PI*8.5){ saveFrame("../savedFiles/" + str(frameCount) + ".png"); exit(); }
  // if (camCurrent > PI*9){ saveFrame("../savedFiles/" + str(frameCount) + ".png"); }



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


void drawGrowingSphere(){

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
