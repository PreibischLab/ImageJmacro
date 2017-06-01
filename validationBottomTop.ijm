// compare the results for the initial and deconvolved images
// left initital image, right -- deconvolved 
// only middle slice is taken

// Close all open tif's 
close("*.tif");

/* 
// Define Input Folders
iniInput = getDirectory("Select a Directory for import");
decInput = getDirectory("Select a Directory for import");
// Define Output Folder
output = getDirectory("Select a Directory for output"); 
*/

// folder name
experimentName = "N2_dpy23_wdr52_mdh1_001";

// Define Input Folders
iniInput = "/home/milkyklim/Documents/data/2017-05-28_smFISH-rex1-deletion/" + experimentName + "/dapi/";
// Define Output Folder
output = "/home/milkyklim/Documents/data/2017-05-28_smFISH-rex1-deletion/" + experimentName + "/bottom-top/";

//Get list of initial file-names
filenames = getFileList(iniInput);
Array.sort(filenames);

setBatchMode(true);
	
for (i = 0; i < filenames.length; i++){
	filename = filenames[i];
	// wqork only with tif files in the folder
	if (endsWith(filename, ".tif") && !startsWith(filename, "psf")){
		// show which file we are processing
		print(filename);
		// progress bar
		showProgress(i + 1, filenames.length);
		iniFile = iniInput + filename;

		// open initial image
		open(iniFile);
		iniTitle = filename;
		selectWindow(iniTitle);
		sliceIdx = 1;		
		setSlice(sliceIdx);
		newLeftTitle = "left.tif";
		run("Duplicate...", "title=" + newLeftTitle + " range=" + sliceIdx);
		run("32-bit");
		run("Grays");

		// adjust the intensity of the initial image
		getStatistics(area, mean, min, max, std, histogram);
		run("Subtract...", "value=" + min);
		run("Divide...", "value=" + (max - min));
						
		// open deconvolved image
		selectWindow(iniTitle);
		sliceIdx = floor(nSlices);		
		setSlice(sliceIdx);
		newRightTitle = "right.tif";
		run("Duplicate...", "title=" + newRightTitle + " range=" + sliceIdx);
		run("32-bit");
		run("Grays");

		// adjust the intensity of the deconvolved image
		getStatistics(area, mean, min, max, std, histogram);
		run("Subtract...", "value=" + min);
		run("Divide...", "value=" + (max - min));

		close(iniTitle);
		run("Combine...", "stack1=" + newLeftTitle + " stack2=" + newRightTitle);
		saveAs("Tiff", output + filename);

		// closed anyways 
		// close(newIniTitle);
		// close(newDecTitle);
		close(filename);		
	}
}

print("DOGE!");