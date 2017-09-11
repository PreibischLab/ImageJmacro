// resave the 16-bit images as 32-bit

// Close all open tif's 
close("*.tif");

// Define Input Folder
// root folder 
input = getDirectory("Select a Directory for import");
// Define Output Folder
// subtracted folder 
output = getDirectory("Select a Directory for output"); // "/Users/kkolyva/Desktop/test_f/d/";

setBatchMode(true);

medianRad = 10; // size of the median filter 

// only 3 first channels are considered
for(j = 0; j < 3; j++){
	channelInput  = input + "channels/c" + (j + 1) + "/";  // this is the folder for each channel
	medianInput   = input + "median/c" + (j + 1) + "/";  // this is the folder for each channel
	channelOutput = output+ "subtracted/c" + (j + 1) + "/";
	
	cFilenames = getFileList(channelInput);
	mFilenames = getFileList(medianInput);
	Array.sort(cFilenames);
	
/*
	for (i = 0; i < filenames.length; i++){	
		// work only on the tif files in the input folder
		if (endsWith(filenames[i], ".tif")){
			// show which file we are processing
			// print(filenames[i]);
			// progress bar
			showProgress(i + 1, filenames.length);
			iFile = channelInput + filenames[i];

			print (iFile);
			
			open(iFile);

			run("32-bit");
			run("Median...", "radius=" + medianRad + " stack");

			oFile = channelOutput + filenames[i];
			saveAs("Tiff", substring(oFile, 0, lengthOf(oFile) - 4));	
			close();
		}
	} */
}

/*
Stack.getStatistics(voxelCount, mean, min, max, stdDev);
run("Subtract...", "value=" + min + " stack");
run("Divide...", "value=" + (max - min) + " stack");

print(min + " " + max);
*/


print("DOGE!");