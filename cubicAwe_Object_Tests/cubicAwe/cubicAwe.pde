import peasy.*;
PeasyCam cam;

// float[][] testVerts  = new float[0][0];
// float[][] testFaces  = new float[0][0];


String dataDir    = "../../data/";

float[][] testVerts;
float[][] testFaces;

int objectVertexs = 0;
int speed = 4;

PVector pointIn;
PVector pointOut;

void setup(){
  // fill(127);
  noCursor();
  noFill();
  //THIS ASSUMES FILES ARE IN: dataDir
  // MATH WORKS BEST WHEN FACES ARE TRIANGLES

  testVerts = getObjArray("supernova.obj", "v ", " ", "/");
  testFaces = getObjArray("supernova.obj", "f ", " ", "/");


  fullScreen(P3D);
  background(10);
  cam = new PeasyCam(this, 500);
  // cam.setSuppressRollRotationMode();
}


int facesX = 0;
int facesY = 0;
PVector previousPoint;

void draw(){
  background(10);

  stroke(255);
  // point(0,0,0);
  // point(100, 0, 0);
  // line(0,0,0, 100, 0, 0);
  // line(0,0,0, 0, 100, 0);
  // line(0,0,0, 0, 0, 100);
  // line(0,100,0, 100, 0, 0);
  // line(0,0,100, 100, 0, 0);
  // line(100,0,0, 0, 0, 100);
  // DRAW OBJECT
  drawObject(testVerts, testFaces, 3, 100, true);

}

/// supernova = 57466



void drawObject(float[][] objVerts, float[][] objFaces, int skip, int scale, boolean draw) {

  stroke(255, 35);

  if (draw){
    // print(objFaces.length);
    for (int x = 0; x < objectVertexs; x++){
      beginShape();
      // +3 or +2 DEPENDING ON THE SHAPE OF THE FACE ARRAY
      for (int y = 0; y < objFaces[x].length; y+=skip){
        int thisVert = int(objFaces[x][y])-1;
        vertex(objVerts[thisVert][0]*scale,objVerts[thisVert][1]*scale,objVerts[thisVert][2]*scale);

      }
      endShape();
    }
  }

  if (objectVertexs < objFaces.length-speed){
    // objectVertexs = speed;
    objectVertexs += speed;
  }

}


float[][] getObjArray(String objFileName, String startSubString, String splitString, String separator){

  String[]    objFile       = loadStrings(dataDir + objFileName);
  String[]    stringArray   = new String[0];

  for (int i =0; i < objFile.length; i++){
    if (objFile[i].substring(0, 2).equals(startSubString)) {
      stringArray = append(stringArray, objFile[i].substring(2));
    }
  }

  float[][] objArray = new float[stringArray.length][0];

  for (int i = 0; i < stringArray.length; i++) {


    String[]  thisString  = split(stringArray[i].replaceAll(separator, " "), splitString);

    float[]   thisArray   = new float[0];

    for (int j = 0; j < thisString.length; j++) {

        objArray[i] = append(objArray[i], float(thisString[j]));

    }

  }

  return objArray;
}
