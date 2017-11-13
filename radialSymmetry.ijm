/*
	This macro triggers the radial symmetry plugin in batch mode
*/

close("*.tif");

// anisotropy in z
anisotropy=1.09;

// use extras
useRansac = "true";
useGaussFit = "false";
bsMethod = "[No background subtraction]";
roiFolder = "";

// DOG params
sigma = 2;
threshold=0.017;

// RANSAC params 
supportRadius=4;
maxError=0.4;
inlierRatio=0.25;

// Define Input Folder
input = "/Users/kkolyva/Desktop/rs-test/input/"; // getDirectory("Select a Directory for import");
// Define Output Folder
output = "/Users/kkolyva/Desktop/rs-test/output/"; // getDirectory("Select a Directory for output");
//Get list of files
filenames = getFileList(input);
// images are not shown
setBatchMode(false);

for (i = 0; i < filenames.length; i++){	
	// input image
	image = filenames[i];
	iFile = input + filenames[i];
	open(iFile);
	// image that is processed:
	print((i + 1) + "/" + filenames.length);
	print(image);
	
	// long command for triggering radial symmetry
	run("Radial Symmetry", 
	"imp=" + image + " " +
	// DOG
	"sigma=" + sigma + " " + "threshold=" + threshold + " " +
	// RANSAC
	"supportradius=" + supportRadius + " " + "inlierratio=" + inlierRatio + " " + "maxerror=" + maxError + " " +
	// extras
	"roifolder=" + roiFolder + " " + "bsmethod=" + bsMethod + " " +
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
	
	// save the result table
	oFile = output + filenames[i];	
	saveAs("Results", substring(oFile, 0, lengthOf(oFile) - 4) + ".csv"); 
	// close the image
	close(image);
	// close the result table
	selectWindow(substring(image, 0, lengthOf(image) - 4) + ".csv"); 
	run("Close");
	showProgress(i + 1, filenames.length);
}