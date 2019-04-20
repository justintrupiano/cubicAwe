import peasy.*;
PeasyCam cam;

String dataDir    = "../../data/";

int canvasW = 1920;
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

PImage auroraImage;

String[] stringArray = new String[0];
String[] auroraFile;

boolean saveFrames = false;
boolean showNums    = false;


void settings(){
  fullScreen(P3D, 1);
}

void setup() {

  cam = new PeasyCam(this, 500);
  // cam.setSuppressRollRotationMode();  // Permit pitch/yaw only.
  cam.setYawRotationMode();

  strokeWeight(4);
  noCursor();

  auroraImage = loadImage(dataDir + "aurora.png");

  ledStrips = new LEDStrip[numStripsHeight][numStripsDepth];
  for (int z = 0; z < numStripsDepth; z++) {
    for (int y = 0; y < numStripsHeight; y++) {
      ledStrips[y][z] = new LEDStrip(y, z);
    }
  }

  //////////////// AURORA STUFF ////////////////
  auroraFile = loadStrings("https://services.swpc.noaa.gov/text/aurora-nowcast-map.txt");

  for (int i = 0; i < auroraFile.length; i++){
    if (!auroraFile[i].substring(0, 1).equals("#")) {
      stringArray = append(stringArray, auroraFile[i].replaceAll("   ", " "));
    }
  }

  aurora = new int[stringArray.length][0];

  for (int i = 0; i < stringArray.length; i++) {
    String[]  thisString  = split(stringArray[i].substring(1), " ");
    String[]   thisArray   = new String[0];
    for (int j = 0; j < thisString.length; j++) {
        aurora[i] = append(aurora[i], int(thisString[j]));
        if (int(thisString[j]) > currentMax){currentMax = int(thisString[j]);}
    }
  }
  //////////////// AURORA STUFF ////////////////
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


void draw() {

    translate(-((xDistBetween)*(numStripsHeight-1))/2, -((yDistBetween)*numStripsDepth)/2, -((zDistBetween)*(numLedPerStrip-1))/2);
    background(0);
    int thisX = 0;
    int thisY = 0;
    int thisZ = 0;
    int thisLength = 15;

    for (int i = 0; i < aurora.length; i++){
      for (int j = 0; j < aurora[i].length; j++){
        if (aurora[i][j] > 0){
          thisX = round(map(i, 0, aurora.length,    0, 15));
          thisY = round(map(j, 0, aurora[i].length, 0, 15));
          for (int k = 0; k < aurora[i][j]; k++){
            thisZ = round(map(k, 0, currentMax, 0, thisLength));
            ledStrips[thisX][thisY].leds[thisZ].thisColor = color(auroraImage.get(ledStrips[thisX][thisY].leds[thisZ].colorImagePos, 1));
          }
        }
        else {ledStrips[thisX][thisY].leds[thisZ].thisColor = color(auroraImage.get(ledStrips[thisX][thisY].leds[thisZ].colorImagePos, 1));;
      }
    }
  }





    for (int z = 0; z < numStripsDepth; z++) {
      for (int y = 0; y < numStripsHeight; y++) {

        ledStrips[y][z].leds[0].thisColor = color(auroraImage.get(ledStrips[z][y].leds[0].colorImagePos, 1));
        ledStrips[y][z].display();

        for (int x = 0; x < numLedPerStrip; x++){
          ledStrips[y][z].leds[x].iterateImagePos();
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
