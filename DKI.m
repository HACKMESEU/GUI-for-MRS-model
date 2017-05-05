function [fa, md, rd, ad, fe, mk,  rk, ak] = DKI(dwi,grad,mask,slice_num)
%%%% Read the dicom files and arrange the data into different positions, B
%%%% values and gradients.
%%%% Get the parameters grad & dwi for function 'dki_fit'. 
% B = [];
% for i=1:(H_num+1)
%     B = [B;Bvalue];
% end
% grad = [H,B];
tic
%%%% Fit the dki.
[b0, dt] = dki_fit(dwi, grad,mask);
%%%% Diffusion and kurtosis tensor parameter calculation.
[fa, md, rd, ad, fe, mk,  rk, ak] = dki_parameters(dt);
toc

for i = 1:slice_num
    if(max(max(mask(:,:,i))))
        figure('NumberTitle', 'off', 'Name', strcat('DKI_','Slice_',num2str(i),'_grey'));
        subplot(2,4,1);
        imshow(fa(:,:,i),[min(min(fa(:,:,i))) max(max(fa(:,:,i)))]),title('FA');
        subplot(2,4,2);
        imshow(md(:,:,i),[min(min(md(:,:,i))) max(max(md(:,:,i)))]),title('MD');
        subplot(2,4,3);
        imshow(rd(:,:,i),[min(min(rd(:,:,i))) max(max(rd(:,:,i)))]),title('RD');
        subplot(2,4,4);
        imshow(ad(:,:,i),[min(min(ad(:,:,i))) max(max(ad(:,:,i)))]),title('AD');
        subplot(2,4,5);
        imshow(b0(:,:,i),[min(min(b0(:,:,i))) max(max(b0(:,:,i)))]),title('B0');
        subplot(2,4,6);
        imshow(mk(:,:,i),[min(min(mk(:,:,i))) max(max(mk(:,:,i)))]),title('MK');
        subplot(2,4,7);
        imshow(rk(:,:,i),[min(min(rk(:,:,i))) max(max(rk(:,:,i)))]),title('RK');
        subplot(2,4,8);
        imshow(ak(:,:,i),[min(min(ak(:,:,i))) max(max(ak(:,:,i)))]),title('AK');

        figure('NumberTitle', 'off', 'Name', strcat('DKI_','Slice_',num2str(i),'_color'));
        subplot(2,4,1);
        imagesc(fa(:,:,i),[min(min(fa(:,:,i))) max(max(fa(:,:,i)))]),title('FA');
        subplot(2,4,2);
        imagesc(md(:,:,i),[min(min(md(:,:,i))) max(max(md(:,:,i)))]),title('MD');
        subplot(2,4,3);
        imagesc(rd(:,:,i),[min(min(rd(:,:,i))) max(max(rd(:,:,i)))]),title('RD');
        subplot(2,4,4);
        imagesc(ad(:,:,i),[min(min(ad(:,:,i))) max(max(ad(:,:,i)))]),title('AD');
        subplot(2,4,5);
        imagesc(b0(:,:,i),[min(min(b0(:,:,i))) max(max(b0(:,:,i)))]),title('B0');
        subplot(2,4,6);
        imagesc(mk(:,:,i),[min(min(mk(:,:,i))) max(max(mk(:,:,i)))]),title('MK');
        subplot(2,4,7);
        imagesc(rk(:,:,i),[min(min(rk(:,:,i))) max(max(rk(:,:,i)))]),title('RK');
        subplot(2,4,8);
        imagesc(ak(:,:,i),[min(min(ak(:,:,i))) max(max(ak(:,:,i)))]),title('AK');
    end
end
