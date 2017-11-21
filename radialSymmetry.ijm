/*
	This macro triggers the radial symmetry plugin in batch mode
*/

close("*.*");

// anisotropy in z
anisotropy=1.09;

// use extras
useRansac = "true";
useGaussFit = "false";
bsMethod = "[No background subtraction]";

// DOG params
sigma = 1.50;
threshold=0.0065;

// RANSAC params 
supportRadius=4;
maxError=0.20;
inlierRatio=0.5034;

// extras
medianRad = 20; // size of the median filter 

// Define Input Folder
input = "/Volumes/Samsung_T3/2017-11-15-deconvolution-data/2017-10-25_smFISH_DPY27KO-tif/N2_DPY23-ex-int_mdh1_003/c1/"; //getDirectory("Select a Directory for import");
// Define ROI Folder
roiFolder = "/Volumes/Samsung_T3/2017-11-15-deconvolution-data/rois/N2_DPY23-ex-int_mdh1_003/"; //getDirectory("Select a Directory for import");
// Define Output Folder
output = "/Volumes/Samsung_T3/2017-11-15-deconvolution-data/2017-10-25_smFISH_DPY27KO-tif/N2_DPY23-ex-int_mdh1_003/c1-result/"; // getDirectory("Select a Directory for output");
//Get list of files
filenames = getFileList(input);
// images are not shown
setBatchMode(true);

for (i = 0; i < filenames.length; i++){	
	// input image
	image = filenames[i];
	iFile = input + filenames[i];
	open(iFile);
	// image that is processed:
	print((i + 1) + "/" + filenames.length);
	print("image: " + image);
	// print(substring(image, 0, lengthOf(image) - 10));

	run("32-bit");	
	// create the image for the backgound
	bgTitle = "bg";
	run("Duplicate...", "title=" + bgTitle + " duplicate");
	run("Median...", "radius=" + medianRad + " stack");
	
	imageCalculator("Subtract create 32-bit stack", image, "bg");

	// check that the dir with the roi's is not empty 
	roiListLength = 1;
	
	// filter out the case when the roi folder is not specified
	if (roiFolder != ""){
		iRoi = roiFolder + (i+1)  + "/"; // substring(image, 0, lengthOf(image) - 10);
		roiList = getFileList(iRoi);
		roiListLength = roiList.length;

		if(roiList.length > 1)
			continue; // test to skip complex images
		
		if (roiList.length == 0 ) // if there are no roi's for the specific file se troi to empty
			iRoi = ""; 
	}
	else
		iRoi = "";

	if (iRoi == "") // skip imags without roi's
		continue;
	
	// long command for triggering radial symmetry
	run("Radial Symmetry", 
	"imp=[" + "Result of " + image + "] " +
	// DOG
	"sigma=" + sigma + " " + "threshold=" + threshold + " " +
	// RANSAC
	"supportradius=" + supportRadius + " " + "inlierratio=" + inlierRatio + " " + "maxerror=" + maxError + " " +
	// extras
	"roifolder=" + iRoi + " " + 
	"bsmethod=" + bsMethod + " " +
	"anisotropy=" + anisotropy + " " + "ransac=" + useRansac + " " + "gaussfit=" + useGaussFit+ " " +
	// Leave these as they are  
	"parametertype=Manual " +
	"showdetections=false " + 
	"showinliers=false " +
	// Should be hidden
	"computationlabel= " +
	"visualizationlabel= " +
	"anisotropylabel=[<html>*Use the \"Anisotropy Coeffcient Plugin\"<br/>to calculate the anisotropy coefficient<br/> or leave 1.00 for a reasonable result.] "
	// DRESDEN: FIX: no clue why do I have these 
	// "context=org.scijava.Context@3d37203b 
	// "guiparams=parameters.GUIParams@7d399648 "
	// "context=org.scijava.Context@3d37203b "
	// "logservice=[org.scijava.log.StderrLogService [priority = -100.0]] "
	// "commandservice=[org.scijava.command.DefaultCommandService [priority = 0.0]] "
	);

	// break;
	// save the result table

	for (j = 0; j < roiListLength; j++){
		oFile = output + filenames[i];	
		saveAs("Results", substring(oFile, 0, lengthOf(oFile) - 4) + "-" + j + ".csv"); 
		print("Result saved!");
	}
	
	// close the image
	close(image);
	close("bg");
	close("Result of " + image);
	// close the result table	
	// print(substring(image, 0, lengthOf(image) - 4) + ".csv");
	// WTF how is possible that the empty result window is not renamed
	// THIS IS ABSOLUTELY FUCKED UP!
	// IJ.renameResults(substring(image, 0, lengthOf(image) - 4) + ".csv");
	// selectWindow(substring(image, 0, lengthOf(image) - 4) + ".csv"); 
	// run("Close");
	showProgress(i + 1, filenames.length);
}