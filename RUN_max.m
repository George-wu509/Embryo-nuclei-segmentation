function RUN_max()

% load previous INPUT from previous code and set up patchs
addpath('[functions]');
addpath('[Segmentation function here]');
addpath('control 1- DAPI and pSmad with cover');
load('Previous_input.mat');

%% ===============  Edit or Write function here  ======================

[maximaintclean, fragall, fragconc, coloroverlay]=maxima3D(smoothdapi, p,iinfo);


% =====================================================================
save('coloroverlay.mat','coloroverlay','maximaintclean');
Raw_image;
end




