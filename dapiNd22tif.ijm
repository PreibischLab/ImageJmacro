// save DAPI channel from the stacks with 4 channels in tif format
// DAPI is 2 channel (0-index!)

// Close all open tif's 
close("*.tif");

// Define Input Folder
input = getDirectory("Select a Directory for import");
 
// Define Output Folder
output = getDirectory("Select a Directory for output"); // "/Users/kkolyva/Desktop/test_f/d/"; 

//Get list of files
filenames = getFileList(input);
Array.sort(filenames);

setBatchMode(true);
	
for (i = 0; i < filenames.length; i++){	
	// work only on the nd2 files
	if (endsWith(filenames[i], ".nd2")){
		// show which file we are processing
		print(filenames[i]);
		// progress bar
		showProgress(i + 1, filenames.length);
		filename = input + filenames[i];
		run("Bio-Formats Importer", "open=[filename] color_mode=Default view=Hyperstack stack_order=XYCZT split_channels");
 		title = substring(filenames[i], 0, lengthOf(filenames[i]) - 4); //Removes .nd2 at the end
	
		// DAPI is always the third channel (0-index!)
		DAPI_index = 4;
		selectWindow(filenames[i] + " - C=" + DAPI_index);
		DAPI_name = title + " - C=" + DAPI_index + ".tif";
		saveAs("Tiff", output + DAPI_name);
		// close(); // don't need in the batch mode
	}
}