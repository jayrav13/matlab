%Jay Ravaliya
%126002593
%Collaborators: Justin Levatino


function varargout = Project3(varargin)
% PROJECT3 M-file for Project3.fig
%      PROJECT3, by itself, creates a new PROJECT3 or raises the existing
%      singleton*.
%
%      H = PROJECT3 returns the handle to a new PROJECT3 or the handle to
%      the existing singleton*.
%
%      PROJECT3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROJECT3.M with the given input arguments.
%
%      PROJECT3('Property','Value',...) creates a new PROJECT3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Project3_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Project3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Project3

% Last Modified by GUIDE v2.5 05-Dec-2009 21:36:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Project3_OpeningFcn, ...
                   'gui_OutputFcn',  @Project3_OutputFcn, ...
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


% --- Executes just before Project3 is made visible.
function Project3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Project3 (see VARARGIN)

% Choose default command line output for Project3
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Project3 wait for user response (see UIRESUME)
% uiwait(handles.figure1);

loc = 1;
slow = 0;
fireC = 0;
fire = 0;
set(handles.slowmotion,'String','Slow Motion: OFF');
% --- Outputs from this function are returned to the command line.
function varargout = Project3_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in play.
function play_Callback(hObject, eventdata, handles)
% hObject    handle to play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mov frame p loc s slow x matG fire fireC
if p == 1
    p = 0;
end
if s == 1
    loc = 1;
    s = 0;
end
for x = loc:length(mov)
    if p == 1
        loc = x;
        break;
    end
    if s == 1;
        loc = 1;
        break;
    end
    frame = mov(x).cdata;
    axes(handles.video1);
    image(frame); 
    axes(handles.video2);
    framebw = RGB2GRAY(frame);
    matG = framebw > 190;
    if(sum(sum(matG)) == 0)
        matG = zeros(size(matG));
        image(matG);
    else
        imagesc(matG);colormap gray; 
    end
    
    if slow == 1
        pause(1/15);
    elseif slow == 0
        pause(1/30);
    end
    set(handles.slider1,'Value',x);
    set(handles.numFrame,'String',x);
    if sum(sum(matG))>4900
        set(handles.display,'String','OMG FIRE');
        set(handles.display,'BackgroundColor','BLACK');
        set(handles.display,'ForegroundColor','RED');
        set(handles.display,'FontWeight','bold');
        set(handles.figure1,'Color','RED');
        set(handles.burningman,'BackgroundColor','RED');
        set(handles.carexplosion,'BackgroundColor','RED');
        set(handles.frame,'BackgroundColor','RED');
        set(handles.numFrame,'BackgroundColor','RED');
        fire = 1;
    elseif sum(sum(matG)) <= 4900
        set(handles.display,'String','No Fire...');
        set(handles.display,'ForegroundColor','BLUE');

        set(handles.figure1,'Color',[0.5 0.5 0.5]);
        set(handles.burningman,'BackgroundColor',[.5 .5 .5]);
        set(handles.carexplosion,'BackgroundColor',[.5 .5 .5]);
        set(handles.frame,'BackgroundColor',[.5 .5 .5]);
        set(handles.numFrame,'BackgroundColor',[.5 .5 .5]);
        set(handles.display,'BackgroundColor','BLACK');
        fire = 1;
    end
end

% --- Executes on button press in pause.
function pause_Callback(hObject, eventdata, handles)
% hObject    handle to pause (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mov frame p loc matG
p = 1;
axes(handles.video1);
image(frame);
axes(handles.video2);
imagesc(matG);

% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mov frame p loc s matG
set(handles.slider1,'Value',1);
set(handles.numFrame,'String',1);
s = 1;
axes(handles.video1);
image(mov(1).cdata);
axes(handles.video2);
 framebw = RGB2GRAY(mov(1).cdata);
 matG = framebw > 190;
    if(sum(sum(matG)) == 0)
        matG = zeros(size(matG));
        image(matG);
    else
        colormap gray; imagesc(matG);
    end

    

% --- Executes on button press in slowmotion.
function slowmotion_Callback(hObject, eventdata, handles)
% hObject    handle to slowmotion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mov frame p loc s slow
if slow ~= 1
    slow = 1;
    set(handles.slowmotion,'String','Slow Motion: ON');
else
    slow = 0;
    set(handles.slowmotion,'String','Slow Motion: OFF');
end
% --- Executes on button press in burningman.
function burningman_Callback(hObject, eventdata, handles)
% hObject    handle to burningman (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of burningman
global mov frame t loc s slow matG stop x
    set(handles.slider1,'Value',1);
    set(handles.numFrame,'String',1);
    set(handles.display,'ForegroundColor','BLUE');
    set(handles.display,'FontWeight','normal');
    set(handles.figure1,'Color',[.5 .5 .5]);
    set(handles.display,'String','No Fire...');
    set(handles.burningman,'BackgroundColor',[.5 .5 .5]);
    set(handles.carexplosion,'BackgroundColor',[.5 .5 .5]);
    
    s = 1;
    loc = 1;
    x = 1;
    
if(get(handles.burningman,'Value') == 1)
    set(handles.carexplosion,'Value',0);
    mov = aviread('burningman.avi');
    axes(handles.video1);
    image(mov(1).cdata);
    axes(handles.video2);
    framebw = RGB2GRAY(mov(1).cdata);
    matG = framebw > 190;
    colormap gray; imagesc(matG);
           
    s = 1;
    slow = 0;
    loc = 1;
    frame = mov(1).cdata;
    
    set(handles.slider1,'Min',1);
    set(handles.slider1,'Max',length(mov));
    set(handles.slider1,'Value',1);
    set(handles.slowmotion,'String','Slow Motion: OFF');
    set(handles.display,'String','No Fire...');
    
    
    
end


% --- Executes on button press in carexplosion.
function carexplosion_Callback(hObject, eventdata, handles)
% hObject    handle to carexplosion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of carexplosion
global mov frame t loc s slow matG stop x
    set(handles.slider1,'Value',1);
    set(handles.numFrame,'String',1);
    set(handles.display,'ForegroundColor','BLUE');
    set(handles.display,'FontWeight','normal');
    set(handles.figure1,'Color',[.5 .5 .5]);
    set(handles.display,'String','No Fire...');
    set(handles.burningman,'BackgroundColor',[.5 .5 .5]);
    set(handles.carexplosion,'BackgroundColor',[.5 .5 .5]);
    
    s = 1;
    loc = 1;
    x = 1;
    
if(get(handles.carexplosion,'Value') == 1)
    set(handles.burningman,'Value',0);
    mov = aviread('carexplosion.avi');
    axes(handles.video1);
    image(mov(1).cdata);
    axes(handles.video2);
    framebw = RGB2GRAY(mov(1).cdata);
    matG = framebw > 190;
    colormap gray; imagesc(matG);
           
    s = 1;
    slow = 0;
    loc = 1;
    frame = mov(1).cdata;
    
    set(handles.slider1,'Min',1);
    set(handles.slider1,'Max',length(mov));
    set(handles.slider1,'Value',1);
    set(handles.slowmotion,'String','Slow Motion: OFF');
    set(handles.display,'String','No Fire...');
    
    
    
end

    
    
% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of
%        slider
global mov frame p loc s slow matG
loc = ceil(get(handles.slider1,'Value'));
p = 1;
frame = mov(loc).cdata;
axes(handles.video1);
    image(frame); 
    axes(handles.video2);
    framebw = RGB2GRAY(frame);
    matG = framebw > 190;
    if(sum(sum(matG)) == 0)
        matG = zeros(size(matG));
        image(matG);
    else
        colormap gray; imagesc(matG);
    end
set(handles.numFrame,'String',loc);
%loc = set(handles.slider1,'Value',get(handles.slider1,'Value'));


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
global mov frame t loc matG
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function display_CreateFcn(hObject, eventdata, handles)
% hObject    handle to display (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global mov frame p loc s slow x matG fire fireC

    
    
        
        
