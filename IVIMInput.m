function [data,b,betta,T] = IVIMInput(dwi,lable,b0,T0,betta0,slice)
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
end
