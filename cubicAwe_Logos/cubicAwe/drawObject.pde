

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
