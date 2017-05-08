function varargout = net1(varargin)
% NET1 M-file for net1.fig
%      NET1, by itself, creates a new NET1 or raises the existing
%      singleton*.
%
%      H = NET1 returns the handle to a new NET1 or the handle to
%      the existing singleton*.
%
%      NET1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NET1.M with the given input arguments.
%
%      NET1('Property','Value',...) creates a new NET1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before net1_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to net1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES


% Last Modified by GUIDE v2.5 07-May-2017 20:26:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @net1_OpeningFcn, ...
                   'gui_OutputFcn',  @net1_OutputFcn, ...
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


% --- Executes just before net1 is made visible.
function net1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to net1 (see VARARGIN)

% Choose default command line output for net1
handles.output = hObject;
movegui(gcf,'center');
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes net1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = net1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.




% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global flg mark rgb graph;
flg=0;   %f初始鼠标没有按下
graph='矩形';
mark='-';
rgb=[1,0,0];

function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global flg  mark rgb x0 y0 x y rect graph;
flg=1;
set(handles.pushbutton2,'enable','on');

currPt = get(gca, 'CurrentPoint');
x = currPt(1,1);
y = currPt(1,2);
line(x,y,'LineStyle',mark,'color',rgb);
x0=x;y0=y;
set(handles.edit1,'string',num2str(x));
set(handles.edit2,'string',num2str(y));
set(handles.text3,'string','Mouse down!');

% --- Executes on mouse motion over figure - except title and menu.
function figure1_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global flg mark rgb x0 y0 x y rect graph h ROI slice slice_num SelectAll;
if flg
    switch(graph)
        case '矩形'
            currPt=get(gca, 'CurrentPoint');
            x=currPt(1,1);
            y=currPt(1,2);
            if x~=x0
                if ~isempty(h)
                    set(h,'Visible','off')
                end
                rect=[min([x0,x]),min([y0,y]),abs(x-x0),abs(y-y0)];
                if rect(3)*rect(4)~=0
                    h=rectangle('Position',rect,'LineStyle',':');
                end
            end
        case '椭圆'
            currPt=get(gca, 'CurrentPoint');
            x=currPt(1,1);
            y=currPt(1,2);
            if x~=x0
                if ~isempty(h)
                    set(h,'Visible','off')
                end
                rect=[min([x0,x]),min([y0,y]),abs(x-x0),abs(y-y0)];
                if rect(3)*rect(4)~=0
                    h=rectangle('Position',rect,'Curvature',[1,1],'LineStyle',':');
                end
            end
    end
    set(handles.edit1,'string',num2str(x));
    set(handles.edit2,'string',num2str(y));
    set(handles.text3,'string','Mouse is moving!');
    ROI(slice,:) = [x0,y0,x,y];
    if(SelectAll)
        for i =1:slice_num
            ROI(i,:) = [x0,y0,x,y];
        end
    end
    
end

function figure1_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global flg rgb mark h graph rect;
flg=0;
switch(graph)
    case '矩形'
        set(h,'Visible','off');h=[];
        if rect(3)*rect(4)~=0
            rectangle('Position',rect,'edgecolor',rgb,'LineStyle',mark)
        end
    case '椭圆'
        set(h,'Visible','off');h=[];
        if rect(3)*rect(4)~=0
            rectangle('Position',rect,'Curvature',[1,1],'edgecolor',rgb,'LineStyle',mark)
        end
end
set(handles.text3,'string','Mouse up!');

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


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



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


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




% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
global mark;
str=get(handles.popupmenu1,'string');
index=get(handles.popupmenu1,'value');
str1=char(str(index));
mark=str1(1:2);


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


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2
global rgb;
str=get(handles.popupmenu2,'string');
index=get(handles.popupmenu2,'value');
str1=char(str(index));
switch (str1)
    case 'red'
        rgb=[1,0,0];
    case 'green'
        rgb=[0,1,0];
    case 'blue'
        rgb=[0,0,1];
    case 'black'
        rgb=[0,0,0];
end
set(handles.edit1,'foregroundcolor',rgb);
set(handles.edit2,'foregroundcolor',rgb);
set(handles.text3,'foregroundcolor',rgb);
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



% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% set(gcf, 'Interruptible', 'off','BusyAction', 'cancel');
% set(gcf, 'WindowButtonMotionFcn', '','Interruptible', 'off');
global Y slice ROI SelectAll slice_num;
cla
axes(handles.axes1);%axes1是坐标轴的标示
imshow(Y, 'DisplayRange',[]); 

ROI(slice,1) = 0;
ROI(slice,2) = 0;
ROI(slice,3) = 0;
ROI(slice,4) = 0;
if (SelectAll)
    for i =1 :slice_num
        ROI(i,1) = 0;
        ROI(i,2) = 0;
        ROI(i,3) = 0;
        ROI(i,4) = 0;
    end
end


set(handles.edit1,'string','');
set(handles.edit2,'string','');
set(handles.text3,'string','');
set(handles.pushbutton2,'enable','off');
%set(handles.pushbutton3,'enable','off');




% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CleanGlobals;
close(gcf);

% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3
global graph flag h mark;
h=[];
str=get(handles.popupmenu3,'string');
index=get(handles.popupmenu3,'value');
graph=char(str(index));
popu={};

        popu={'- 实线';'--虚线';': 点线';'-.虚点线';};
        set(handles.popupmenu1,'string',popu);
        set(handles.popupmenu1,'value',1);
        set(handles.text4,'string','选择LineType')
        mark='-';

% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%  清 屏
function CleanGlobals
% Clean up the global workspace
clear global flg mark rgb x0 y0 x y rect graph h Y dwi lable slice ROI mask grad slice_num b T betta;


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla
global Y dwi lable slice ROI grad slice_num b T betta row column;

DicomFolder = uigetdir({}, '选择文件夹');

if DicomFolder == 0
    return;
end
h = msgbox('The data is loading......');
[dwi,grad,lable,b,T,betta,row,column]=Read_DICOM(DicomFolder);

set(handles.Slice_slider,'Value',1);
set(handles.Slice_slider,'Max',max(lable(:,3)));
set(handles.Slice_slider,'Min',min(lable(:,3)));
if(max(lable(:,3))-1 == 0)
else
    set(handles.Slice_slider,'sliderstep',[1/(max(lable(:,3))-1) 1/(max(lable(:,3))-1)]);
end
slice_num = (max(lable(:,3)));

%h = msgbox('The data is ready.');


ROI = zeros(slice_num,4);

slice = 1;
for i = 1:length(lable)
    if(lable(i,3) == slice)
        break
    end
end
Y = dwi(:,:,slice,i);
axes(handles.axes1);%axes1是坐标轴的标示
imshow(Y, 'DisplayRange',[]);    
set(handles.edit_slice,'String', '1');  

 















% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over popupmenu1.
function popupmenu1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function Slice_slider_Callback(hObject, eventdata, handles)
% hObject    handle to Slice_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global dwi Y lable slice ROI graph x0 y0 x y;
slice =  get(handles.Slice_slider,'Value'); 
set(handles.edit_slice,'String', num2str(slice)); 
for i = 1:length(lable)
    if(lable(i,3) == slice)
        break
    end
end
Y = dwi(:,:,slice,i);
axes(handles.axes1);%axes1是坐标轴的标示
imshow(Y, 'DisplayRange',[]);  

global flg rgb mark h ;
flg=0;
rect=[min([ROI(slice,1),ROI(slice,3)]),min([ROI(slice,2),ROI(slice,4)]),abs(ROI(slice,1)-ROI(slice,3)),abs(ROI(slice,2)-ROI(slice,4))];
switch(graph)
    case '矩形'
        set(h,'Visible','off');h=[];
        if rect(3)*rect(4)~=0
            rectangle('Position',rect,'edgecolor',rgb,'LineStyle',mark)
        end
    case '椭圆'
        set(h,'Visible','off');h=[];
        if rect(3)*rect(4)~=0
            rectangle('Position',rect,'Curvature',[1,1],'edgecolor',rgb,'LineStyle',mark)
        end
end








% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function Slice_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Slice_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit_slice_Callback(hObject, eventdata, handles)
% hObject    handle to edit_slice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_slice as text
%        str2double(get(hObject,'String')) returns contents of edit_slice as a double


% --- Executes during object creation, after setting all properties.
function edit_slice_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_slice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global dwi mask grad slice_num ROI lable slice;
mask = false(176,176,slice_num);

for i =1 :slice_num
    if( ROI(i,1)* ROI(i,3)~= 0)
        mask(int16(ROI(i,2)):int16(ROI(i,4)),int16(ROI(i,1)):int16(ROI(i,3)),i) = true;
    end
end
if (max(lable(:,4))>=3 && max(lable(:,2))>=15)
    if(max(max(ROI)))
        [fa, md, rd, ad, fe, mk,  rk, ak] = DKI(dwi,grad,mask,slice_num);
        for i =1 :slice_num
            if( ROI(i,1)* ROI(i,3)~= 0)
                 OutputPath = strcat('result\','DKI_','Slice',num2str(i),'_fa');
                 xlswrite(OutputPath,fa(:,:,i));
                 OutputPath = strcat('result\','DKI_','Slice',num2str(i),'_md');
                 xlswrite(OutputPath,md(:,:,i)); 
                 OutputPath = strcat('result\','DKI_','Slice',num2str(i),'_rd');
                 xlswrite(OutputPath,rd(:,:,i));
                 OutputPath = strcat('result\','DKI_','Slice',num2str(i),'_ad');
                 xlswrite(OutputPath,ad(:,:,i));
                 OutputPath = strcat('result\','DKI_','Slice',num2str(i),'_fe');
                 xlswrite(OutputPath,fe(:,:,i));
                 OutputPath = strcat('result\','DKI_','Slice',num2str(i),'_mk');
                 xlswrite(OutputPath,mk(:,:,i));
                 OutputPath = strcat('result\','DKI_','Slice',num2str(i),'_rk');
                 xlswrite(OutputPath,rk(:,:,i));
                 OutputPath = strcat('result\','DKI_','Slice',num2str(i),'_ak');
                 xlswrite(OutputPath,ak(:,:,i));
            end
        end
        msgbox('Save data OK , please check the result folder');
         
    else
        msgbox('DKI failed:please choose ROI.');
    end
else
    msgbox('DKI failed: The DKI requires at least 3 different B values and 15 different Gradient.');
end



% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
global SelectAll ;
SelectAll = get(hObject,'Value');


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes during object creation, after setting all properties.
function text8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function checkbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton_ivin.
function pushbutton_ivin_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ivin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global dwi lable  b T betta ROI slice_num row column ;
if(max(max(ROI)) == 0)
    msgbox('IVIM failed: please choose ROI.');
end
for i =1 :slice_num
    if( ROI(i,1)* ROI(i,3)~= 0)
        [data,b0,betta0,T0] = IVIMInput(dwi,lable,b,T,betta,i);
        mask = zeros(row,column);
        mask(int16(ROI(i,2)):int16(ROI(i,4)),int16(ROI(i,1)):int16(ROI(i,3))) = 1;
        [b0,D,f,tau,v,Dstar,Dhighb, fhighb,r] = IVIM(data,b0,betta0,T0,mask,i);
        
        OutputPath = strcat('result\','IVIM_','Slice',num2str(i),'_b0');
        xlswrite(OutputPath,b0(:,:));
        OutputPath = strcat('result\','IVIM_','Slice',num2str(i),'_D');
        xlswrite(OutputPath,D(:,:)); 
        OutputPath = strcat('result\','IVIM_','Slice',num2str(i),'_f');
        xlswrite(OutputPath,f(:,:));
        OutputPath = strcat('result\','IVIM_','Slice',num2str(i),'_tau');
        xlswrite(OutputPath,tau(:,:)); 
        OutputPath = strcat('result\','IVIM_','Slice',num2str(i),'_v');
        xlswrite(OutputPath,v(:,:));
        OutputPath = strcat('result\','IVIM_','Slice',num2str(i),'_Dstar');
        xlswrite(OutputPath,Dstar(:,:)); 
        OutputPath = strcat('result\','IVIM_','Slice',num2str(i),'_Dhighb');
        xlswrite(OutputPath,Dhighb(:,:));
        OutputPath = strcat('result\','IVIM_','Slice',num2str(i),'_fhighb');
        xlswrite(OutputPath,fhighb(:,:)); 
        OutputPath = strcat('result\','IVIM_','Slice',num2str(i),'_r');
        xlswrite(OutputPath,r(:,:)); 
        
    end
end
msgbox('Save data OK , please check the result folder');


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global slice lable dwi ROI slice_num row column b
if(max(max(ROI)) == 0)
    msgbox('SE failed: please choose ROI.');
end
for i =1 :slice_num
    if( ROI(i,1)* ROI(i,3)~= 0)
        mask = zeros(row,column);
        mask(int16(ROI(i,2)):int16(ROI(i,4)),int16(ROI(i,1)):int16(ROI(i,3))) = 1;
        bvalue = [];
        data = [];
        num =1;
        for j = 1:length(b)
            if((lable(j,3)==i)&&(lable(j,2)==1))
                bvalue = [bvalue,b((lable(j,1)))];
                data(:,:,num) = dwi(:,:,i,j);
                num = num + 1;
            end
        end
        [DDC,a] = SE(data,bvalue,mask,row,column);
        figure('NumberTitle', 'off', 'Name', strcat('SE_','Slice_',num2str(i))),imagesc(real(a)),colorbar,title('a value map');
        figure('NumberTitle', 'off', 'Name', strcat('SE_','Slice_',num2str(i))),imagesc(real(DDC)),colorbar,title('DDC value map');
        OutputPath = strcat('result\','SE_','Slice',num2str(i),'_a');
        xlswrite(OutputPath,a(:,:));
        OutputPath = strcat('result\','SE_','Slice',num2str(i),'_DDC');
        xlswrite(OutputPath,DDC(:,:));
        
    end
end
msgbox('Save data OK , please check the result folder');



% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global slice lable dwi ROI slice_num row column b
if(max(max(ROI)) == 0)
    msgbox('SE failed: please choose ROI.');
end
for i =1 :slice_num
    if( ROI(i,1)* ROI(i,3)~= 0)
        mask = zeros(row,column);
        mask(int16(ROI(i,2)):int16(ROI(i,4)),int16(ROI(i,1)):int16(ROI(i,3))) = 1;
        bvalue = [];
        data = [];
        num =1;
        for j = 1:length(b)
            if((lable(j,3)==i)&&(lable(j,2)==1))
                bvalue = [bvalue,b((lable(j,1)))];
                data(:,:,num) = dwi(:,:,i,j);
                num = num + 1;
            end
        end
        [adc] = ADC(data,bvalue,mask,row,column);
         figure('NumberTitle', 'off', 'Name', strcat('ADC_','Slice_',num2str(i))),imagesc(adc),colorbar,title('ADC value map');
         OutputPath = strcat('result\','ADC_','Slice',num2str(i),'_adc');
        xlswrite(OutputPath,adc(:,:));
        
    end
end
msgbox('Save data OK , please check the result folder');