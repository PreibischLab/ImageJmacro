// crop the deconvolved images to the initial dimensions

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

// adjust these correspondenly
halfPsfDims = newArray(105, 105, 48);
	
for (i = 0; i < filenames.length; i++){	
	// work only on the tif files in the input folder
	if (endsWith(filenames[i], ".tif")){
		// show which file we are processing
		print(filenames[i]);
		// progress bar
		showProgress(i + 1, filenames.length);
		iFile = input + filenames[i];
		open(iFile);
	
		// all images to deconvolve have the different size in z-axis
		zDim = nSlices - (halfPsfDims[2]*2 + 1);
		imgDims = newArray(1024, 1024, zDim);
         
		// print(halfPsfDims[0] + " " + halfPsfDims[1] + " " +  imgDims[0] + " " +  imgDims[1]);     		
		makeRectangle(halfPsfDims[0], halfPsfDims[1], imgDims[0], imgDims[1]);
		run("Duplicate...", "duplicate range=" + (halfPsfDims[2] + 1) + "-" + (halfPsfDims[2] + imgDims[2] + 1));

		oFile = output + filenames[i];
		saveAs("Tiff", substring(oFile, 0, lengthOf(oFile) - 10));	
	}
}

print("DOGE!");