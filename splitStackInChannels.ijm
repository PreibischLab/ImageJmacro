// resave stack as separate channels 
// Define Input Folder
input = getDirectory("Input");

// Define Output Folder
output = getDirectory("Output");

//Get list of files
filenames = getFileList(input);
Array.sort(filenames);
// images are not shown
setBatchMode(true);
	
for (i = 0; i < filenames.length; i++){	
	// work only on the tif files in the input folder
	if (endsWith(filenames[i], ".tif")){
		// show which file we are processing
		print(filenames[i]);
		// progress bar
		showProgress(i + 1, filenames.length);
		iFile = input + filenames[i];
		open(iFile);

		getDimensions(width, height, channels, slices, frames);
	
		run("Split Channels");
		// close all channels
		for (j = 0; j < channels; j++){
			title = getTitle();
			oFile = output + title;
			Stack.setDimensions(1, slices, 1); // is this legit ? 
			run("32-bit"); 
			saveAs("Tiff", oFile);	
			close();
		}
	}
}

print("DOGE!");