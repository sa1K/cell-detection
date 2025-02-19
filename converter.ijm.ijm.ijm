// ask user to select a folder
dir = getDirectory("Select A folder");
// get the list of files (& folders) in it
fileList = getFileList(dir);
// prepare a folder to output the images
output_dir = dir + File.separator + "output";
File.makeDirectory(output_dir);
output_dir1 = output_dir + File.separator +"cells"+ File.separator;
output_dir2 = output_dir + File.separator +"foci"+ File.separator;
File.makeDirectory(output_dir1);
File.makeDirectory(output_dir2);


//activate batch mode
setBatchMode(true);

// LOOP to process the list of files
for (i = 0; i < lengthOf(fileList); i++) {
	// define the "path" 
	// by concatenation of dir and the i element of the array fileList
	current_imagePath = dir+fileList[i];
	// check that the currentFile is not a directory
	if (!File.isDirectory(current_imagePath)){
		// open the image and split
		open(current_imagePath);
		//run("Bio-Formats Windowless Importer", "open=" + current_imagePath);
		// get some info about the image
		getDimensions(width, height, channels, slices, frames);
		// if it's a multi channel image , or a RGB
		if ((channels > 1)||( bitDepth() == 24 )){
			run("Z Project...", "projection=[Max Intensity]");
			run("Split Channels");
		}
		// now we save all the generated images as jpg in the output_dir
		ch_nbr = nImages ;
		for ( c = 2 ; c <= ch_nbr ; c++){
			selectImage(c);
			//if picture of cells save in cells folder
			if(c==2){
				currentImage_name = getTitle();
				saveAs("jpg", output_dir1+currentImage_name);	
			}
			//if foci pic save in foci folder
			else if(c==3){
				currentImage_name = getTitle();
				saveAs("jpg", output_dir2+currentImage_name);
			}
		}
		// make sure to close every images befores opening the next one
		run("Close All");
	}
}
print("all converted");
setBatchMode(false);