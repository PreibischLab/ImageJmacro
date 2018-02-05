// resave each series from the .nd file 
// output: the stack with 5 channels in tif format

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

	// work only on the nd2 files
	if (endsWith(filename, ".nd2")){
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
			run("Bio-Formats Importer", "open=[" + img + "] color_mode=Default view=Hyperstack stack_order=XYCZT series_" + iSeries);
			// choose series
			Ext.setSeries(iSeries - 1);
			
			// single series image should be processed separetely
			if (nSeries == 1){
				title = filename;
				outFilename = substring(filename, 0, lengthOf(filename) - 4) + "-(series " + IJ.pad(iSeries, numZeros) + ")"; 
			}
			else{
				title = filename + " - " + filename + " (series " + IJ.pad(iSeries, numZeros) + ")";
				outFilename = substring(filename, 0, lengthOf(filename) - 4) + "-(series " + IJ.pad(iSeries, numZeros) + ")"; 
			}
	
			print("Title: " + title);
			print("Output filename: " + outFilename);
			 
			selectWindow(title);	
			saveAs("Tiff", output + outFilename + ".tif");	
			Ext.close();
			// this close looks necessary, hm 
			close();
			showProgress(iSeries, nSeries);
		}		
	}
} 