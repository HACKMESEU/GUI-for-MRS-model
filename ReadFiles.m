
function [data,b,betta,T,mask]=ReadFiles(DicomFolder,slice)
    
[dwi,grad,lable,b0,T0,betta0,row,column]=Read_DICOM(DicomFolder);
slice = 1;
data = [];
b = [];
betta = [];
T = [];
j =1;
for i = 1:length(lable)
    if(lable(i,3) == slice) 
       data(j,:,:) = dwi(:,:,slice,i);
       b(j) = b0(i);
       betta(j) = betta0(i);
       T(j) = T0(i);
       j = j+1;
    end
end
b = b';
betta = betta';
T = T';
mask = zeros(row,column);
mask(80:100,80:100) = 1;
end