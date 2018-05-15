// create a max-projection of the resliced image 

// Close all open tif's and nd2's
close("*.tif");

// don't show images
setBatchMode(true);

// Define Input Folder
input = getDirectory("Select a Directory for import");

// Define Output Folder
output = getDirectory("Select a Directory for output"); // "/Users/kkolyva/Desktop/test_f/d/";

// Get list of files
filenames = getFileList(input);
Array.sort(filenames);

for (iFile = 0; iFile < filenames.length; ++iFile){
	img = input + filenames[iFile];
	filename = filenames[iFile];
	// work only on the nd2 files
	if (endsWith(filename, ".tif")){
		// image path
		print(img);

		open(img);

		run("Select None");
		run("Reslice [/]...", "output=1.000 start=Top avoid");
		run("Z Project...", "projection=[Max Intensity]");

		saveAs("Tiff", output + filename);	
		// close("*.*")

		showProgress(iFile, filenames.length);
	}		
} 

print("DOGE!");