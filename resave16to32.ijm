// resave the 16-bit images as 32-bit

// Close all open tif's 
close("*.tif");

// Define Input Folder
input = getDirectory("Select a Directory for import");
// Define Output Folder
output = getDirectory("Select a Directory for output"); // "/Users/kkolyva/Desktop/test_f/d/";

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
	
		run("32-bit");

		oFile = output + filenames[i];
		saveAs("Tiff", substring(oFile, 0, lengthOf(oFile) - 10));	
		close();
	}
}

print("DOGE!");