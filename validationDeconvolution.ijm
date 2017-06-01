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
experimentName = "N2_dpy23_wdr52_mdh1_002";

// Define Input Folders
iniInput = "/home/milkyklim/Documents/data/2017-05-28_smFISH-rex1-deletion/" + experimentName + "/dapi/";
decInput = "/home/milkyklim/Documents/data/2017-05-28_smFISH-rex1-deletion/" + experimentName + "/output/";
// Define Output Folder
output = "/home/milkyklim/Documents/data/2017-05-28_smFISH-rex1-deletion/" + experimentName + "/validation/";

//Get list of initial file-names
filenames = getFileList(iniInput);
Array.sort(filenames);

setBatchMode(true);

// SEA12_dpy23_wdr52_mdh1_006.nd2 - SEA12_dpy23_wdr52_mdh1_006.nd2 (series 01) - C=3
// SEA12_dpy23_wdr52_mdh1_006.nd2 - SEA12_dpy23_wdr52_mdh1_006.nd2 (series 02) - C=3
	
for (i = 0; i < filenames.length; i++){
	filename = filenames[i];
	// wqork only with tif files in the folder
	if (endsWith(filename, ".tif") && !startsWith(filename, "psf")){
		// show which file we are processing
		print(filename);
		// progress bar
		showProgress(i + 1, filenames.length);
		iniFile = iniInput + filename;
		decFile = decInput + filename; // imagej behavior for the same file names  

		// open initial image
		open(iniFile);
		iniTitle = filename;
		selectWindow(iniTitle);
		sliceIdx = floor(nSlices/2);		
		setSlice(sliceIdx);
		newIniTitle = "left.tif";
		run("Duplicate...", "title=" + newIniTitle + " range=" + sliceIdx);
		run("32-bit");
		run("Grays");

		// adjust the intensity of the initial image
		getStatistics(area, mean, min, max, std, histogram);
		run("Subtract...", "value=" + min);
		run("Divide...", "value=" + (max - min));
				
		close(iniTitle);
		// open deconvolved image
		open(decFile);
		decTitle = substring(filename, 0, lengthOf(filename) - 4) + ".tif" ;
		selectWindow(decTitle);
		sliceIdx = floor(nSlices/2);		
		setSlice(sliceIdx);
		newDecTitle = "right.tif";
		run("Duplicate...", "title=" + newDecTitle + " range=" + sliceIdx);

		// adjust the intensity of the deconvolved image
		getStatistics(area, mean, min, max, std, histogram);
		run("Subtract...", "value=" + min);
		run("Divide...", "value=" + (max - min));
		
		close(decTitle);
		run("Combine...", "stack1=" + newIniTitle + " stack2=" + newDecTitle);
	
		saveAs("Tiff", output + filename);

		// closed anyways 
		// close(newIniTitle);
		// close(newDecTitle);
		close(filename);		
	}
}

print("DOGE!");