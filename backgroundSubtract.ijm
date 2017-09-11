// subtract the background

// Close all open tif's 
close("*.tif");

// Define the folder with files
// root folder 
folder = getDirectory("Select a Directory for import");

setBatchMode(true);

medianRad = 10; // size of the median filter 

// only 3 first channels are considered
for(j = 0; j < 3; j++){
	channelInput  = folder + "channels/c" + (j + 1) + "/";  // this is the folder for each channel
	medianInput   = folder + "median/c" + (j + 1) + "/";  // this is the folder for each channel
	channelOutput = folder+ "subtracted/c" + (j + 1) + "/";

	// print(channelInput);
	// print(medianInput);
	
	cFilenames = getFileList(channelInput);
	mFilenames = getFileList(medianInput);
		
	for (i = 0; i < cFilenames.length; i++){	
		// work only on the tif files in the input folders
		if (endsWith(cFilenames[i], ".tif")){
			// show which file we are processing
			// print(cFilenames[i]);
			// progress bar
			showProgress(i + 1, cFilenames.length);
			icFile = channelInput + cFilenames[i]; // path
			imFile = medianInput  + mFilenames[i]; // path
			
			// print(icFile);
			open(icFile); 
			// initial images are 16-bit
			run("32-bit"); 
			open(imFile);
			
			imageCalculator("Subtract create 32-bit stack", cFilenames[i], mFilenames[i]);

			Stack.getStatistics(voxelCount, mean, min, max, stdDev);
			run("Add...", "value=" + (-1*min) + " stack");

			ocFile = channelOutput + cFilenames[i];
			saveAs("Tiff", substring(ocFile, 0, lengthOf(ocFile) - 4));	
			// Close all open tif's 
			close("*.tif");
		}
	}
}

/*
Stack.getStatistics(voxelCount, mean, min, max, stdDev);
run("Subtract...", "value=" + min + " stack");
run("Divide...", "value=" + (max - min) + " stack");

print(min + " " + max);
*/


print("DOGE!");