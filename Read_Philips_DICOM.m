% for PHILIPS DICOM images consisting of magnitude and phase parts
%   [H,H_num,pos_num,Bvalue,volumn_data]ir] =Read_Philips_DICOM(DicomFolder);
%
%   output
%   H - the diffusion gradient 
%   H_num - the number of H
%   pos_num - the number of position 
%   Bvalue - the B value
%   volumn_data - the volumn data,eg [128 128 H_num pos_num]
%   input
%   DicomFloder: This folder should NOT contain anything else 
%                except the DICOM images belonging to a particular
%                series that you want to process.
%
%   Apdated from Tian Liu
%   Created by Shuai Wang on 2013.07.19 
%   Last modified by Tian Liu on 2013.08.06


function [dwi,grad,lable]=Read_Philips_DICOM(DicomFolder)
   
    filelist = dir(DicomFolder);
    i=1;
    while i<=length(filelist)
        if filelist(i).isdir==1
            filelist = filelist([1:i-1 i+1:end]);   % skip folders
        else
            i=i+1;
        end
    end

    fnTemp=[DicomFolder '/' filelist(1).name];
    
    lable = [];
    H = [];
    position = [];
    Bvalue = [];
    
    for i = 1:length(filelist) 
        info = dicominfo([DicomFolder '/' filelist(i).name]);
        %Bvalue =  info.DiffusionBValue;
        if(isempty(H))
            H = [info.DiffusionGradientOrientation'];
            lable_H = 1;
        else
            size_H = size(H);
            H_same = 0;
            for j = 1:(size_H(1))
                if(isequal(info.DiffusionGradientOrientation',H(j,:)))
                   H_same = 1;
                   lable_H = j;
                end
            end
            if(H_same == 0)
                H = [H;info.DiffusionGradientOrientation'];
                size_H = size(H);
                lable_H = size_H(1);
            end
        end
       
        if(isempty(position))
            position = [info.ImagePositionPatient'];
            lable_p = 1;
        else
            size_position = size(position);
            position_same = 0;
            for k = 1:(size_position(1))
                if(isequal(info.ImagePositionPatient',position(k,:)))
                   position_same = 1;
                   lable_p = k;
                end
            end
            if(position_same == 0)
                position = [position;info.ImagePositionPatient'];
                size_position = size(position);
                lable_p = size_position(1);
            end
        end 
        
        if(isempty(Bvalue))
            Bvalue = [info.DiffusionBValue'];
            lable_b = 1;
        else
            size_b = size(Bvalue);
            b_same = 0;
            for k = 1:(size_b(1))
                if(isequal(info.DiffusionBValue',Bvalue(k,:)))
                   b_same = 1;
                   lable_b = k;
                end
            end
            if(b_same == 0)
                Bvalue = [Bvalue;info.DiffusionBValue'];
                size_b = size(Bvalue);
                lable_b = size_b(1);
            end
         end 
        
        lable = [lable;i lable_H lable_p lable_b];
   
    end
  %  lable = sortrows(lable,2);
    pos_num = size_position(1);
    H_num = size_H(1)-1;  %except the H [0 0 0]    
    grad = [];
    for i = 1:length(filelist)
        %if (lable(i,2)==1)
        %else
        dwi(:,:,lable(i,3),i) = single(dicomread([DicomFolder '/' filelist(lable(i,1)).name]));
        %end
    end

    for i = 1:length(filelist)
        temp = [H(lable(i,2),:),Bvalue(lable(i,4))];
        grad = [grad;temp];
    end

end