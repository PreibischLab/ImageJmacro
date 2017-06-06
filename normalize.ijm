// normalize open image

selectWindow(getTitle());

run("Duplicate...",  "duplicate title=[new name 1]");
// adjust the intensity of the initial image
Stack.getStatistics(voxelCount, mean, min, max, stdDev);
run("Subtract...", "value=" + min + " stack");
run("Divide...", "value=" + (max - min) + " stack");

print(min + " " + max);

print("DOGE!");// compare the results for the initial and deconvolved images