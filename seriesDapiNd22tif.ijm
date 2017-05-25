// save DAPI channel from the series files each of them 
// is the stack with 4 channels in tif format
// DAPI is 3 channel (0-index!)s

// Close all open tif's 
close("*.tif");

// run bio-format extension
run("Bio-Formats Macro Extensions");

// don't show images
setBatchMode(true);

// Define Input Folder
input = getDirectory("Select a Directory for import");

// Define Output Folder
output = getDirectory("Select a Directory for output"); // "/Users/kkolyva/Desktop/test_f/d/";

// Get list of files
filenames = getFileList(input);
Array.sort(filenames);

// image for testing 
// img = "/Volumes/Samsung_T3/2017-05-22_smFISH-rex1-deletion/N2_DPY-23_wdr5.5_mdh-1_002.nd2";

for (iFile = 0; iFile < filenames.length; ++iFile){
	img = input + filenames[iFile];
	filename = filenames[iFile];
	// image path
	print(img);
	// get the metadata of the file
	Ext.setId(img);
	// get the number of images (series)
	Ext.getSeriesCount(nSeries);
	
	// count number of leading zeros
	numZeros = 0;
	tmp = nSeries;
	while (tmp > 0){
		tmp = floor(tmp / 10);
		numZeros++;
	}
	
	// iterate over all images in the series
	for (iSeries = 1; iSeries <= nSeries; iSeries++){
		print("Processing series #" + iSeries);
		run("Bio-Formats Importer", "open=[" + img + "] color_mode=Default view=Hyperstack stack_order=XYCZT series_" + iSeries + " split_channels");
		// choose series
		Ext.setSeries(iSeries - 1);
		
		// DAPI is always the third channel (0-index!)
		DAPI_index = 3;
		// single series omage should be processed separetely
		if (nSeries == 1){
			title = filename + " - C=" + DAPI_index;
		}
		else{
			title = filename + " - " + filename + " (series " + IJ.pad(iSeries, numZeros) + ") "+ "- C=" + DAPI_index;
		}

		print(title);
		selectWindow(title);	
		saveAs("Tiff", output + title + ".tif");	
		showProgress(iSeries, nSeries);
	}		
} 