function varargout = Raw_image(varargin)
% RAW_IMAGE MATLAB code for Raw_image.fig
%      RAW_IMAGE, by itself, creates a new RAW_IMAGE or raises the existing
%      singleton*.
%
%      H = RAW_IMAGE returns the handle to a new RAW_IMAGE or the handle to
%      the existing singleton*.
%
%      RAW_IMAGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RAW_IMAGE.M with the given input arguments.
%
%      RAW_IMAGE('Property','Value',...) creates a new RAW_IMAGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Raw_image_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Raw_image_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Raw_image

% Last Modified by GUIDE v2.5 04-Oct-2016 23:53:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Raw_image_OpeningFcn, ...
                   'gui_OutputFcn',  @Raw_image_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT
end

% --- Executes just before Raw_image is made visible.
function Raw_image_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Raw_image (see VARARGIN)


%% load p.mat
rootfolder = pwd;
savefolder = [rootfolder '/[functions]/io.mat'];
if ispc ==1
    savefolder(findstr(savefolder, '/'))='\';
end
load(savefolder);


%% set handles.popupmenu1 String = image names
for i=1:size(imagename,2)
    popname{i,1} = imagename{1,i};
end
set(handles.popupmenu1,'String',popname);


%% Default load first image information
d_fol = data_folder{1};
s_fol = [d_fol '/stack.mat'];
d_fol = [d_fol '/p.mat'];
if ispc ==1
    d_fol(findstr(d_fol, '/'))='\';
    s_fol(findstr(s_fol, '/'))='\';
end
load(d_fol);load(s_fol);load('coloroverlay.mat');
handles.NFstk = NFstk;
if exist('coloroverlay','var')~=0
    handles.coloroverlay = coloroverlay;
end

%% setup handles.slider1,edit1, popupmenu2, axes1 property according to image1
% setup popupmenu2
set(handles.popupmenu2,'String',chal_info(:,3));

% setup handles.slider1
set(handles.slider1,'Max',size(NFstk{1,1},3));set(handles.slider1,'Min',1);
set(handles.slider1, 'SliderStep', [1/(size(NFstk{1,1},3)-1) , 1/(size(NFstk{1,1},3)-1) ]);
set(handles.slider1,'String',num2str(1));set(handles.slider1,'Value',1);

% setup handles.edit1
set(handles.edit1,'String','1');


%% load maxcolorbar properties
maxcolorbar_input=str2num(get(handles.edit2,'String'));


%% show axes1
myImage = NFstk{1,1}(:,:,1);
maxcolorbar=256;
if max(max(max(NFstk{1,1})))>500;maxcolorbar =65535;end
if maxcolorbar_input~=0;maxcolorbar=maxcolorbar_input;end
set(handles.axes1,'Units','pixels');
resizePos = get(handles.axes1,'Position');
myImage= imresize(myImage, [resizePos(3) resizePos(3)]);
axes(handles.axes1);
imagesc(myImage);colorbar;caxis([0 maxcolorbar]);
set(handles.axes1,'Units','normalized');

%% show axes2
if isfield(handles,'coloroverlay') ==1
    set(handles.axes2,'Units','pixels');
    axes(handles.axes2);
    imshow(coloroverlay(:,:,1:3));colorbar;
    set(handles.axes2,'Units','normalized');
    axis on;
end


%% Choose default command line output for Raw_image
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Raw_image wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% load p.mat
rootfolder = pwd;
savefolder = [rootfolder '/[functions]/io.mat'];
if ispc ==1
    savefolder(findstr(savefolder, '/'))='\';
end
load(savefolder);


%% input popupmenu1 value
image_no= get(handles.popupmenu1,'Value');


%% Default load first image information
d_fol = data_folder{image_no};
s_fol = [d_fol '/stack.mat'];
d_fol = [d_fol '/p.mat'];
if ispc ==1
    d_fol(findstr(d_fol, '/'))='\';
    s_fol(findstr(s_fol, '/'))='\';
end
load(d_fol);load(s_fol);
handles.NFstk = NFstk;


%% load edit1, popupmenu2 properties
chal_no=get(handles.popupmenu2,'Value');
page_no=str2num(get(handles.edit1,'String'));


%% load maxcolorbar properties
maxcolorbar_input=str2num(get(handles.edit2,'String'));


%% show axes1
myImage = NFstk{1,chal_no}(:,:,page_no);
maxcolorbar=256;
if max(max(max(handles.NFstk{1,1})))>500;maxcolorbar =65535;end
if maxcolorbar_input~=0;maxcolorbar=maxcolorbar_input;end
set(handles.axes1,'Units','pixels');
resizePos = get(handles.axes1,'Position');
myImage= imresize(myImage, [resizePos(3) resizePos(3)]);
axes(handles.axes1);
imagesc(myImage);colorbar;caxis([0 maxcolorbar]);
set(handles.axes1,'Units','normalized');


%% show axes2
if isfield(handles,'coloroverlay') ==1
    set(handles.axes2,'Units','pixels');
    axes(handles.axes2);
    imshow(coloroverlay(:,:,(page_no-1)*3+1:(page_no-1)*3+3));colorbar;
    set(handles.axes2,'Units','normalized');
    axis on;
end


% update handles
guidata(hObject, handles);
end


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% input edit value and update slider1 and popupmenu2
chal_no=get(handles.popupmenu2,'Value');
page_no=round(str2num(get(handles.edit1,'String')));
if page_no>size(handles.NFstk{1,1},3)
    page_no=size(handles.NFstk{1,1},3);
elseif page_no<1
    page_no=1;
end
set(handles.slider1,'Value',page_no);
set(handles.edit1,'String',num2str(page_no));
guidata(hObject, handles);


%% load maxcolorbar properties
maxcolorbar_input=str2num(get(handles.edit2,'String'));


%% show axes1
myImage = handles.NFstk{1,chal_no}(:,:,page_no);
maxcolorbar=256;
if max(max(max(handles.NFstk{1,1})))>500;maxcolorbar =65535;end
if maxcolorbar_input~=0;maxcolorbar=maxcolorbar_input;end
set(handles.axes1,'Units','pixels');
resizePos = get(handles.axes1,'Position');
myImage= imresize(myImage, [resizePos(3) resizePos(3)]);
axes(handles.axes1);
imagesc(myImage);colorbar;caxis([0 maxcolorbar]);
set(handles.axes1,'Units','normalized');


%% show axes2
if isfield(handles,'coloroverlay') ==1
    set(handles.axes2,'Units','pixels');
    axes(handles.axes2);
    imshow(handles.coloroverlay(:,:,(page_no-1)*3+1:(page_no-1)*3+3));colorbar;
    set(handles.axes2,'Units','normalized');
    axis on;
end


% update handles
guidata(hObject, handles);
end

% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% input popupmenu2 value
chal_no=get(handles.popupmenu2,'Value');


%% load edit1 properties
page_no=str2num(get(handles.edit1,'String'));


%% load maxcolorbar properties
maxcolorbar_input=str2num(get(handles.edit2,'String'));


%% show axes1
myImage = handles.NFstk{1,chal_no}(:,:,page_no);
maxcolorbar=256;
if max(max(max(handles.NFstk{1,1})))>500;maxcolorbar =65535;end
if maxcolorbar_input~=0;maxcolorbar=maxcolorbar_input;end
set(handles.axes1,'Units','pixels');
resizePos = get(handles.axes1,'Position');
myImage= imresize(myImage, [resizePos(3) resizePos(3)]);
axes(handles.axes1);
imagesc(myImage);colorbar;caxis([0 maxcolorbar]);
set(handles.axes1,'Units','normalized');


%% show axes2
if isfield(handles,'coloroverlay') ==1
    set(handles.axes2,'Units','pixels');
    axes(handles.axes2);
    imshow(handles.coloroverlay(:,:,(page_no-1)*3+1:(page_no-1)*3+3));colorbar;
    set(handles.axes2,'Units','normalized');
    axis on;
end


% update handles
guidata(hObject, handles);
end

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% input edit1 value and update slider1
page_no = round(get(handles.slider1,'Value'));
set(handles.edit1,'String',num2str(page_no));


%% load popupmenu2 properties
chal_no=get(handles.popupmenu2,'Value');


%% load maxcolorbar properties
maxcolorbar_input=str2num(get(handles.edit2,'String'));


%% show axes1
myImage = handles.NFstk{1,chal_no}(:,:,page_no);
maxcolorbar=256;
if max(max(max(handles.NFstk{1,1})))>500;maxcolorbar =65535;end
if maxcolorbar_input~=0;maxcolorbar=maxcolorbar_input;end
set(handles.axes1,'Units','pixels');
resizePos = get(handles.axes1,'Position');
myImage= imresize(myImage, [resizePos(3) resizePos(3)]);
axes(handles.axes1);
imagesc(myImage);colorbar;caxis([0 maxcolorbar]);
set(handles.axes1,'Units','normalized');


%% show axes2
if isfield(handles,'coloroverlay') ==1
    set(handles.axes2,'Units','pixels');
    axes(handles.axes2);
    imshow(handles.coloroverlay(:,:,(page_no-1)*3+1:(page_no-1)*3+3));colorbar;
    set(handles.axes2,'Units','normalized');
    axis on;
end


% update handles
guidata(hObject, handles);
end


function edit2_Callback(hObject, eventdata, handles)


%% input edit1 value and update slider1
page_no = round(get(handles.slider1,'Value'));
set(handles.edit1,'String',num2str(page_no));


%% load popupmenu2 properties
chal_no=get(handles.popupmenu2,'Value');

%% load maxcolorbar properties
maxcolorbar_input=str2num(get(handles.edit2,'String'));


%% show axes1
myImage = handles.NFstk{1,chal_no}(:,:,page_no);
maxcolorbar=256;
if max(max(max(handles.NFstk{1,1})))>500;maxcolorbar =65535;end
if maxcolorbar_input~=0;maxcolorbar=maxcolorbar_input;end
set(handles.axes1,'Units','pixels');
resizePos = get(handles.axes1,'Position');
myImage= imresize(myImage, [resizePos(3) resizePos(3)]);
axes(handles.axes1);
imagesc(myImage);colorbar;caxis([0 maxcolorbar]);
set(handles.axes1,'Units','normalized');


%% show axes2
if isfield(handles,'coloroverlay') ==1
    set(handles.axes2,'Units','pixels');
    axes(handles.axes2);
    imshow(handles.coloroverlay(:,:,(page_no-1)*3+1:(page_no-1)*3+3));colorbar;
    set(handles.axes2,'Units','normalized');
    axis on;
end


% update handles
guidata(hObject, handles);
end


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Dault colorbar max value setup
maxyo=get(handles.checkbox1,'Value');
if maxyo==1
    set(handles.edit2,'Visible','Off');
    set(handles.edit2,'String','0');
elseif maxyo==0
    set(handles.edit2,'Visible','On');
end


%% input edit1 value and update edit1
page_no=round(str2num(get(handles.edit1,'String')));


%% load popupmenu2 properties
chal_no=get(handles.popupmenu2,'Value');


%% load maxcolorbar properties
maxcolorbar_input=str2num(get(handles.edit2,'String'));


%% show axes1
myImage = handles.NFstk{1,chal_no}(:,:,page_no);
maxcolorbar=256;
if max(max(max(handles.NFstk{1,1})))>500;maxcolorbar =65535;end
if maxcolorbar_input~=0;maxcolorbar=maxcolorbar_input;end
set(handles.axes1,'Units','pixels');
resizePos = get(handles.axes1,'Position');
myImage= imresize(myImage, [resizePos(3) resizePos(3)]);
axes(handles.axes1);
imagesc(myImage);colorbar;caxis([0 maxcolorbar]);
set(handles.axes1,'Units','normalized');


%% show axes2
if isfield(handles,'coloroverlay') ==1
    set(handles.axes2,'Units','pixels');
    axes(handles.axes2);
    imshow(handles.coloroverlay(:,:,(page_no-1)*3+1:(page_no-1)*3+3));colorbar;
    set(handles.axes2,'Units','normalized');
    axis on;
end




% update handles
guidata(hObject, handles);
end

% -------------------------------------------------------------

% --- Outputs from this function are returned to the command line.
function varargout = Raw_image_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
end

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
