

// void drawAurora(){
//     PVector pos,
//     float[][] objVerts,
//     float[][] objFaces,
//     int skip, int scale
//     ) {
//
//       // if (draw){
//       //     noFill();
//       //   // pushMatrix();
//       //     // translate(pos.x, pos.y, pos.z);
//       //     for (int x = 0; x < objFaces.length; x++){
//       //
//       //       // beginShape();
//       //       // +3 or +2 DEPENDING ON THE SHAPE OF THE FACE ARRAY
//       //
//       //       for (int y = 0; y < objFaces[x].length; y+=skip){
//       //         int thisVert = int(objFaces[x][y])-1;
//       //         // vertex( Math.round(objVerts[thisVert][0]*scale),
//       //         //         Math.round(objVerts[thisVert][1]*scale),
//       //         //         Math.round(objVerts[thisVert][2]*scale)
//       //         //         );
//       //         Math.round(objVerts[thisVert][0]*scale)
//       //         Math.round(objVerts[thisVert][1]*scale)
//       //         Math.round(objVerts[thisVert][2]*scale)
//       //
//       //       }
//       //
//       //       // endShape();
//       //     }
//       //   // popMatrix();
//       // }
//
//   }
//
//
// float[][] getObjArray(String objFileName, String startSubString, String splitString, String separator){
//
//   String[]    objFile       = loadStrings(dataDir + objFileName);
//   String[]    stringArray   = new String[0];
//
//   for (int i =0; i < objFile.length; i++){
//     if (objFile[i].substring(0, 2).equals(startSubString)) {
//       stringArray = append(stringArray, objFile[i].substring(2));
//     }
//   }
//
//   float[][] objArray = new float[stringArray.length][0];
//
//   for (int i = 0; i < stringArray.length; i++) {
//
//     String[]  thisString  = split(stringArray[i].replaceAll(separator, " "), splitString);
//
//     float[]   thisArray   = new float[0];
//
//     for (int j = 0; j < thisString.length; j++) {
//         objArray[i] = append(objArray[i], float(thisString[j]));
//     }
//   }
//
//   return objArray;
// }
