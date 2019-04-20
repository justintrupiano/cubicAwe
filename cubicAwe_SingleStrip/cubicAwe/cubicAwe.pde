import peasy.*;
PeasyCam cam;

String dataDir    = "../../data/";

int canvasW = 1080;
int canvasH = 1080;

float scale 			    = 0.75;
float[][] objArray;
float[][] cube        = new float[0][0];

int numStripsHeight  	= 1;
int numLedPerStrip  	= 16;
int numStripsDepth  	= 1;

int xDistBetween  		= 100;
int yDistBetween  		= 100;
int zDistBetween  		= 100;

int imageSize         = 4000;

int currentMax        = 0;

int saveFrameNum      = 0;

int[] splitArray;
int[][] aurora;

LEDStrip[][] ledStrips;

PImage rainbowImage;
PImage sunFlicker;

String[] stringArray = new String[0];
String[] auroraFile;

boolean saveFrames  = false;
boolean showNums    = false;


void settings(){
  fullScreen(P3D, 1);
  // size(canvasW, canvasH, P3D);
}


void setup() {

  cam = new PeasyCam(this, 500);
  cam.setSuppressRollRotationMode();  // Permit pitch/yaw only.

  strokeWeight(4);
  noCursor();
  textSize(15);

  sunFlicker = loadImage(dataDir + "sunFlicker.png");

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

String[] testing = new String[0];
int pos = 0;
int changePos = 1;

void draw() {
  translate(-((xDistBetween-1)*numLedPerStrip)*0.5, -((yDistBetween-1)*numStripsHeight)*0.5, -((zDistBetween-1)*numStripsDepth)*0.5);
  background(0);
  int thisX = 0;
  int thisY = 0;
  int thisZ = 0;
  // int thisLength = (random(1)>0.5) ? 10 : 15;
  int thisLength = 15;

  testing = new String[0];

  for (int x = 0; x < numStripsDepth; x++) {
    for (int y = 0; y < numStripsHeight; y++) {
      for (int z = 0; z < numLedPerStrip; z++){
        ledStrips[x][y].leds[z].thisColor = color(sunFlicker.get(ledStrips[x][y].leds[z].colorImagePos, int(map(z, 0, 15, sunFlicker.height, 0))));
        // ledStrips[x][y].leds[z].thisColor = color(pos, pos, pos);

        testing = append(testing, hex(ledStrips[x][y].leds[z].thisColor, 6));

      }
    }
  }

  if (pos > 255 || pos < 0){
    changePos *= -1;
  }

  pos += changePos;



  // SAVING FILES //
  // RUN PYTHON SCRIPT
  // THEN RUN BASH SCRIPT:
  // cat result.txt | tr -d '\n' > oneline.txt
  saveStrings( "./frames/" + nf(frameCount, 5) + ".txt", testing);
  if(frameCount == 4000){exit();}

  /////////////////





  for (int x = 0; x < numStripsDepth; x++) {
    for (int y = 0; y < numStripsHeight; y++) {

      /// DISPLAY CURRENT FRAME ///
      ledStrips[x][y].display();

      for (int z = 0; z < numLedPerStrip; z++){

        ledStrips[x][y].leds[z].iterateImagePos(1);

        if(showNums){
          text("(" +str(x) + ", "+ str(y) +", " + str(z) + ") ", x * xDistBetween, y* yDistBetween, z * zDistBetween);
        }



      }

    }
  }

  if (saveFrames){
    saveFrame("../savedFiles/" + str(saveFrameNum) + ".png");
    saveFrameNum += 1;
  }


}
