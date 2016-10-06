# Embryo_nuclei_segmentation

 ![image](https://github.com/George-wu509/Embryo-nuclei-segmentation/blob/master/%5Bfunctions%5D/1.png)


Introduction
-------------------------
To identify Zebrafish embryo nucleus from images, we apply 3D image segmentation to detect target and locate nuclei xyz coordinates. In here we develop and test different 3D segmentation code functions to improve the ability to find nuclei maxima from smoothed iamges. A GUI is also included to show segmentation result and compare with raw images.  


How to run
-------------------------
Two matlab-GUI related code: Customer_GUI.m and Customer_GUI.fig are provided. 
The subfolder /pre_data shoud contains three matlab data file: train.mat, test.mat, 
and ID.mat which are training dataset, testing dataset, and testing ID from Santander 
Customer Satisfaction website. Of course, you should have matlab installed in your compyter.  


What included
-------------------------

* RUN_max.m
* R
* Normalization
* Binary
