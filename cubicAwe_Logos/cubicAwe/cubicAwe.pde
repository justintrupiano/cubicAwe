import peasy.*;
PeasyCam cam;

String dataDir    = "../../data/";

int canvasW = 1080;
int canvasH = 1080;

float scale 			    = 0.75;
float[][] objArray;
float[][] cube        = new float[0][0];

int numStripsHeight  	= 16;
int numLedPerStrip  	= 16;
int numStripsDepth  	= 16;

int xDistBetween  		= 100;
int yDistBetween  		= 100;
int zDistBetween  		= 100;

int imageSize         = 4000;

int currentMax        = 0;

int saveFrameNum      = 0;

int[] splitArray;
int[][] aurora;

LEDStrip[][] ledStrips;

PImage starFieldImage;
PImage cuLogo;

String[] stringArray = new String[0];
String[] auroraFile;

boolean saveFrames  = true;
boolean showNums    = false;


void settings(){
  fullScreen(P3D, 1);
  // size(canvasW, canvasH, P3D);
}


void setup() {

  cam = new PeasyCam(this, 1000);
  // cam.setSuppressRollRotationMode();  // Permit pitch/yaw only.
  cam.setYawRotationMode();

  strokeWeight(6);
  noCursor();
  textSize(15);

  starFieldImage = loadImage(dataDir + "starField.png");
  cuLogo = loadImage(dataDir + "cuLogoSmallBlackBG.png");

  ledStrips = new LEDStrip[numStripsHeight][numStripsDepth];
  for (int z = 0; z < numStripsDepth; z++) {
    for (int y = 0; y < numStripsHeight; y++) {
      ledStrips[y][z] = new LEDStrip(y, z);
    }
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

double camRotate = 0.0025;
// double camRotate = 0.0;
double camCurrent = camRotate;

void draw() {

  background(0);

  camCurrent += camRotate;
  cam.rotateY(camRotate);

  translate(-((xDistBetween)*(numStripsHeight-1))/2, -((yDistBetween)*numStripsDepth)/2, -((zDistBetween)*(numLedPerStrip-1))/2);

  int thisX = 0;
  int thisY = 0;
  int thisZ = 0;
  // int thisLength = (random(1)>0.5) ? 10 : 15;
  int thisLength = 15;



  for (int x = 0; x < numLedPerStrip; x++){
    for (int y = 0; y < numLedPerStrip; y++){
      for (int z = 0; z < numLedPerStrip; z++){
        ledStrips[z][y].leds[x].thisColor = color(starFieldImage.get(ledStrips[x][y].leds[z].colorImagePos, 1));

      }
    }
  }


  // for (int x = 0; x < cuLogo.width; x++){
  //   for (int y = 0; y < cuLogo.height; y++){
  //
  //     color thisPosColor = cuLogo.get(x, y);
  //     if (thisPosColor != color(0,0,0)){
  //       for (int z = 7; z < 10; z++){
  //         ledStrips[z][y].leds[x].thisColor = thisPosColor;
  //
  //       }
  //     }
  //   }
  // }



  for (int x = 0; x < numStripsDepth; x++) {
    for (int y = 0; y < numStripsHeight; y++) {

      /// DISPLAY CURRENT FRAME ///
      ledStrips[x][y].display();
      // text("(" +str(x) + ", "+ str(y) + ") ", x * 100, y* 100);

      for (int z = 0; z < numLedPerStrip; z++){

        ledStrips[x][y].leds[z].iterateImagePos(1);
        if(showNums){
          text("(" +str(x) + ", "+ str(y) +", " + str(z) + ") ", x * xDistBetween, y* yDistBetween, z * zDistBetween);
        }

      }

    }
  }

  for (int x = 0; x < numStripsDepth; x++) {
    for (int y = 0; y < numStripsHeight; y++) {
      ledStrips[x][y].display();
    }
  }

  if (saveFrames){
    saveFrame("../savedFiles/" + str(saveFrameNum) + ".png");
    saveFrameNum += 1;
  }
  if (camCurrent > TWO_PI * 4){exit();}




}
