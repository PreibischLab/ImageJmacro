// merge all images into one file 

// Close all open tif's 
close("*.tif");

experimentName = "N2_dpy23_wdr52_mdh1_002";

setBatchMode(true);

// Define Output Folder
// output = getDirectory("Select a Directory for output");
// Define Output Folder
output = "/home/milkyklim/Documents/data/2017-05-28_smFISH-rex1-deletion/" + experimentName + "/validation/";
// merge all images 
filenames = getFileList(output);
Array.sort(filenames);

for (i = 0; i < filenames.length; i++){
	filename = filenames[i];
	// wqork only with tif files in the folder
	if (endsWith(filename, ".tif") && !startsWith(filename, "all")){
		// show which file we are processing
		print(filename);
		// progress bar
		showProgress(i + 1, filenames.length);
		file = output + filename;
		
		// open initial image
		open(file);
		title = filename;
	}
}

run("Images to Stack", "name=[" + "all_" + experimentName + "] title=[" + experimentName + "] use");
saveAs("Tiff", output + "all_" + experimentName);

print("DOGE!");