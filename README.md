# Embryo_nuclei_segmentation

 ![image](https://github.com/George-wu509/Embryo-nuclei-segmentation/blob/master/%5Bfunctions%5D/1.png)


Introduction
-------------------------
To identify Zebrafish embryo nucleus from images, we apply 3D image segmentation to detect target and locate nuclei xyz coordinates. In here we develop and test different 3D segmentation code functions to improve the ability to find nuclei maxima from smoothed iamges. I have packed necessary code files here, and a GUI is also included to show segmentation result and compare with raw images.  


How to run?
-------------------------
1. download this repository to your local computer, it should contains RUN_max.m, Previous_result.mat, README.md, and three folders described in what included.
2. Run RUN_max.m in matlab. 


How to test new function?
-------------------------
1. A new segmentation function code should contains the same input and output as original 'maxima3D' code.
2. put your new segmentation code in folder /[Segmentation function here]
3. Replace the ''maxima3D'' in line 11 of RUN_max() as your new function.


INPUT and OUTPUT
-------------------------
INPUT 
  maximaintclean= a matrix output of the maxima coordinates in [x1,y1;xy,y2;,x3,y3;...] format
  fragall=all of the maxima that were closer together than 'dist'
  fragconc=the maxima after they are combined into a single averaged point
  coloroverlay: 2D slices showing the gaussian smoothed images with centerpoints highlighted in purple
OUTPUT
  smoothdapi=stack of greyscale images  (x by y by z array)
  p.noisemax=maxima below this threshhold will be flattenned (imhmax()) (usually 10)
  p.noisemin=minima less than this value are eliminated using (imhmin()) (usually 10)
  p.pix=number of pixels in xy direction (usually 1024)
  p.dist=2 nuclei closer than this in pixels will be combined  (usually 6)
  p.showimage:determines whether to show the images or not  (0=no, 1=yes)


What included? 
-------------------------

* RUN_max.m
* Previous_result.mat
* README.md 
* /[Segmentation function here] folder contains maxima3D.m
* /[[functions]] folder contains Raw_image.fig, Raw_image.m, io.mat, and i.png
* /[control 1- DAPI and pSmad with cover] folder contains p.mat, stack.mat

