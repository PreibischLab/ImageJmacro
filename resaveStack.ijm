// resave the stack as separate images 

// setBatchMode(true);

// Define Output Folder
output = getDirectory("Select a Directory for output");
initImageID = getImageID;
selectImage(initImageID);

run("Stack to Images");

close(initImageID);	// close the initial image
titles = getList("image.titles"); // get the list of the open images

for (i = 0; i < titles.length; i++){
	selectWindow(titles[i]);
	saveAs("Png", output + "image" + "-" + i);
	close("image" + "-" + i + ".png");	
}

print("DOGE!");