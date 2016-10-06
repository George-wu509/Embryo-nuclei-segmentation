function [maximaintclean, fragall, fragconc, coloroverlay]=maxima3D(smoothdapi, p,iinfo)
%outputs maximas from a 3-D matlab image
%
% OUTPUT:
% maximaintclean= a matrix output of the maxima coordinates in [x1,y1;xy,y2;,x3,y3;...] format
% fragall=all of the maxima that were closer together than 'dist'
% fragconc=the maxima after they are combined into a single averaged point
% coloroverlay: 2D slices showing the gaussian smoothed images with centerpoints highlighted in purple
%
% INPUT:
% smoothdapi=stack of greyscale images  (x by y by z array)
% p.noisemax=maxima below this threshhold will be flattenned (imhmax()) (usually 10)
% p.noisemin=minima less than this value are eliminated using (imhmin()) (usually 10)
% p.pix=number of pixels in xy direction (usually 1024)
% p.dist=2 nuclei closer than this in pixels will be combined  (usually 6)
% p.showimage:determines whether to show the images or not  (0=no, 1=yes)
% x1, y1, z1 size of disk in pixels for display purposes.  2/3 of the entered x and y used.
% note: z1 has been locked at 1
load('Previous_input.mat');  % INPUT from previous code



%% load parameters
noisemin=p.id_noisemin;
noisemax=p.id_noisemax;
dist=p.id_dist;
showimage=p.id_showimage;
saveim=p.id_saveim;
x1=p.id_x1;
y1=p.id_y1;
z1=p.id_z1;
zxyratio=3.2051;          %ratio over distance in z direction per pixel over distance in xy per pixel (3.97 is for 2.2 um z slices)
fragconc=[];
fragall=[];
maximaintclean=[];


%% Convert image 16bit intensity(0-65535) into 0-256
if max(max(max(smoothdapi)))>500
    smoothdapi8=double(smoothdapi)/65535*256;
else
    smoothdapi8=uint8(smoothdapi);
end


%% finds maximas(centroids) and puts the into the format [x1,y1,z1;x2,y2,z2;x3,y3,z3...]
% -- use H-min, H-max and imregionalmax to define possible nuclei
blobmax=imhmin(smoothdapi8, noisemin);      % Local min + 10
blobmax=imhmax(blobmax, noisemax);          % Local max -10
blobmax=imregionalmax(blobmax);             % Find local max
sharpmax=bwulterode(blobmax);               % Ultimate erosion

% -- finds middle of each maxima cluster
maximas=regionprops(sharpmax, 'Centroid');  % maximas: Nx1 struct, call using maximas(1).Centroid = [x,y,z] 

% -- converts structured array to numerical
maximacell=struct2cell(maximas);
maximamat=cell2mat(maximacell);
maximanum=ctranspose(reshape(maximamat,3,[]));       %turns [x1,y1,x2,y2,x3,y3...]-->[x1,x2,x3;y1,y2,y3...]-->[x1,y1;x2,y2;x3,y3...]   
maximaint=round(maximanum);                         %'maximaint is a rounded version of maximanum for purposes of points = [x1,y1,z1;x2,y2,z2;x3,y3,z3...]


%% This sections combines maxima that are too close to each other
% -- identifies any points closer than 'dist' to each other
for i=1:size(maximanum, 1)        % loops i from 2 to the bottom of the zview input matrix, marking the row.
    xvalue=maximanum(i,1);
    yvalue=maximanum(i,2);
    Zvalue=maximanum(i,3);
    
    % -- distance from this point to all other points
    testdist= ((maximanum(:,1)- xvalue).^2 + (maximanum(:,2)- yvalue).^2+((maximanum(:,3)- Zvalue).*zxyratio).^2).^.5 ;     % subtracts these values from the entire corresponding zyx columns from the xview     
    nucrow=[];
    [nucrow, ~]=find(abs(testdist)<dist );          %finds any rows in the incoming column whos xy distance is less than 'dist' away from the point in question
    
    % -- records all maxima that did not have any other maxima closer than 'dist'
    if numel(nucrow) <= 1                           
        maximaintin=maximaint(i,:);
        maximaintclean=cat(1,maximaintclean,maximaintin);
    end;
    
    % -- this row records all nuclei that were closer together than dist
    if numel(nucrow) > 1                            
        fragin=maximaint(i,:);
        fragall=cat(1,fragall,fragin);
    end;
end;


%% combines points identified in previous step as being too close.  averages them and makes a single point
if numel(fragall)>0   
    fragsort=sortrows(fragall);

    for u=1:size(fragsort,1)
        testdist2= ((fragsort(:,1)-fragsort(u,1) ).^2 + (fragsort(:,2)-fragsort(u,2)).^2+((fragsort(:,3)-fragsort(u,3)).*zxyratio).^2).^.5 ;     %subtracts these values from the entire corresponding zyx columns from the xview 
        nucrow2=[];
        [nucrow2, ~]=find(abs(testdist2)<dist );

        %fragsort(nucrow2, 3)=u;
        coprow=[];
        fragconcin=round(cat(2,mean(fragsort(nucrow2,1)), mean(fragsort(nucrow2,2)), mean(fragsort(nucrow2,3))));           %this makes the xy coordinates of any nuclei within the critical distance the average of those nuclei

        if u==1                                                                 %this if statement parsaes each member of the list and removes duplicates
            fragconc=cat(1, fragconc, fragconcin);              
        else
            [coprow, ~]=find(fragconc(:,1)==fragconcin(1,1) & fragconc(:,2)==fragconcin(1,2) & fragconc(:,3)==fragconcin(1,3));
            if isempty(coprow)==1
                fragconc=cat(1, fragconc, fragconcin);
            end
        end
    end
end
maximaintclean=cat(1,maximaintclean,fragconc);  %adds the combined points into the rest of the set


%% optional: Outputs centroids of image onto old image in color%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
currentim=uint8(zeros(iinfo.Height, iinfo.Width, size(smoothdapi8, 3)));   %creates new binary cube of all zeros
disksize=round(max(iinfo.Height, iinfo.Width)/1024*4);                 %specifies disk size relative to pixels
   
        for z=1:size(maximaintclean, 1)                              %takes image of 0s and makes maximas 255
             currentim(maximaintclean(z,2),maximaintclean(z,1), maximaintclean(z,3))=150;

        end;

        %dialimage=imdilate(currentim, strel('disk',disksize));              %dilates those maximas (labelled 255) to disks of 'disksize'
        z1=1;
        h = fspecial3_mod('ellipsoid', [round(x1*2/3),round(y1*2/3),z1]);

        dialimage=imfilter(currentim,h);
        dialimage=dialimage.*64;
        %coloroverlay=uint8(zeros(pix, pix, 3*size(smoothdapi8, 3)));
        %colorlist=cat(3,dialimage,smoothdapi8, smoothdapi8);
        coloroverlay=[];
        coloroverlay=dialimage(:,:,1);
        coloroverlay=cat(3, coloroverlay, smoothdapi8(:,:,1));
        coloroverlay=cat(3, coloroverlay, smoothdapi8(:,:,1));
        
        for u=2:size(smoothdapi8, 3)
            %overlays maxima onto original and displays
            coloroverlay=cat(3,coloroverlay, dialimage(:,:,u));
            coloroverlay=cat(3, coloroverlay, smoothdapi8(:,:,u));
            coloroverlay=cat(3, coloroverlay, smoothdapi8(:,:,u));

            
        end;
        
if showimage==1        
        
        for u=1:3:size(coloroverlay, 3)
            figure(round(u/3)+1)
            imshow(coloroverlay(:,:,u:u+2))
            if saveim==1
                        saveas(figure(round(u/3)+1), ['slice ' num2str(round(u/3)+1) 'maximas.jpg'])
            end;
                close(figure(round(u/3)+1))
        end;
end;

    function h = fspecial3_mod(type,siz,siz2)
%FSPECIAL3 Create predefined 3-D filters.
%   H = FSPECIAL3(TYPE,SIZE) creates a 3-dimensional filter H of the
%   specified type and size. Possible values for TYPE are:
%
%     'average'    averaging filter
%     'ellipsoid'  ellipsoidal averaging filter
%     'gaussian'   Gaussian lowpass filter
%     'laplacian'  Laplacian operator
%     'log'        Laplacian of Gaussian filter
%
%   The default SIZE is [5 5 5]. If SIZE is a scalar then H is a 3D cubic
%   filter of dimension SIZE^3.
%
%   H = FSPECIAL3('average',SIZE) returns an averaging filter H of size
%   SIZE. SIZE can be a 3-element vector specifying the dimensions in
%   H or a scalar, in which case H is a cubic array.
%
%   H = FSPECIAL3('ellipsoid',SIZE) returns an ellipsoidal averaging filter.
%
%   H = FSPECIAL3('gaussian',SIZE) returns a centered Gaussian lowpass
%   filter of size SIZE with standard deviations defined as
%   SIZE/(4*sqrt(2*log(2))) so that FWHM equals half filter size
%   (http://en.wikipedia.org/wiki/FWHM). Such a FWHM-dependent standard
%   deviation yields a congruous Gaussian shape (what should be expected
%   for a Gaussian filter!).
%
%   H = FSPECIAL3('laplacian') returns a 3-by-3-by-3 filter approximating
%   the shape of the three-dimensional Laplacian operator. REMARK: the
%   shape of the Laplacian cannot be adjusted. An infinite number of 3D
%   Laplacian could be defined. If you know any simple formulation allowing
%   one to control the shape, please contact me.
%
%   H = FSPECIAL3('log',SIZE) returns a rotationally symmetric Laplacian of
%   Gaussian filter of size SIZE with standard deviation defined as
%   SIZE/(4*sqrt(2*log(2))).
%
%   Class Support
%   -------------
%   H is of class double.
%
%   Example
%   -------
%      I = single(rand(80,40,20));
%      h = fspecial3('gaussian',[9 5 3]); 
%      Inew = imfilter(I,h,'replicate');
%       
%   See also IMFILTER, FSPECIAL.
%
%   -- Damien Garcia -- 2007/08

type = lower(type);

if nargin==1
        siz = 5;
end

if numel(siz)==1
    siz = round(repmat(siz,1,3));
elseif numel(siz)~=3
    error('Number of elements in SIZ must be 1 or 3')
else
    siz = round(siz(:)');
end

switch type
    
    case 'average'
        h = ones(siz)/prod(siz);
        
    case 'gaussian'
        sig = siz2/(4*sqrt(2*log(2)));
        siz   = (siz-1)/2;
        [x,y,z] = ndgrid(-siz(1):siz(1),-siz(2):siz(2),-siz(3):siz(3));
        h = exp(-(x.*x/2/sig(1)^2 + y.*y/2/sig(2)^2 + z.*z/2/sig(3)^2));
        h = h/sum(h(:));
        
    case 'ellipsoid'
        R = siz/2;
        R(R==0) = 1;
        h = ones(siz);
        siz = (siz-1)/2;
        [x,y,z] = ndgrid(-siz(1):siz(1),-siz(2):siz(2),-siz(3):siz(3));
        I = (x.*x/R(1)^2+y.*y/R(2)^2+z.*z/R(3)^2)>1;
        h(I) = 0;
        h = h/sum(h(:));
        
    case 'laplacian'
        h = zeros(3,3,3);
        h(:,:,1) = [0 3 0;3 10 3;0 3 0];
        h(:,:,3) = h(:,:,1);
        h(:,:,2) = [3 10 3;10 -96 10;3 10 3];
        
    case 'log'
        sig = siz/(4*sqrt(2*log(2)));
        siz   = (siz-1)/2;
        [x,y,z] = ndgrid(-siz(1):siz(1),-siz(2):siz(2),-siz(3):siz(3));
        h = exp(-(x.*x/2/sig(1)^2 + y.*y/2/sig(2)^2 + z.*z/2/sig(3)^2));
        h = h/sum(h(:));
        arg = (x.*x/sig(1)^4 + y.*y/sig(2)^4 + z.*z/sig(3)^4 - ...
            (1/sig(1)^2 + 1/sig(2)^2 + 1/sig(3)^2));
        h = arg.*h;
        h = h-sum(h(:))/prod(2*siz+1);
        
    otherwise
        error('Unknown filter type.')
        
end
end
end