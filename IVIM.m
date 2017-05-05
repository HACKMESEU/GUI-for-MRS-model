% !!! Calculation of parameter maps takes some time !!! 
%% calculate parameter maps for all 6 volunteer data sets (approx 35 min).

%for each volunteer
function [b0,D,f,tau,v,Dstar,Dhighb, fhighb,r] = IVIM(data,b,betta,T,mask,slice) 
%slice =1;
%[data,b,betta,T,mask] = ReadFiles('C:\Users\dell\Desktop\GUI0327\72BCD4FF68E247B690C1E3CDD8304126',slice);
%load('C:\Users\dell\Desktop\IVIM\ivim_tools-master\data\volunteer1.mat');
%3x3 median filter
for i = 1:size(data, 1)
    data(i, :, :) = medfilt2(reshape(data(i, :), size(data, 2), size(data, 3)), [3 3]);
end
%T = [40;40;40;40;40;40;40;40;40;40;40;40;40;40;40;40;40;40;40;40;40;40;40;40;40;40;40;40;40;40;70;70;70];
%betta = [1;1;2;2;2;2;2;2;2;2;2;1;1;1;1;1;1;2;1;1;1;1;1;1;2;2;1;1;1;1;1;1;2];
%average over diffusion directions
%[data, betta, b, T] = trace(data, betta, b, T);
b0 = mean(data(b == 0, mask > 0), 1);
data = data(b > 0, mask > 0);
T = T(b > 0);
betta = betta(b > 0);
b = b(b > 0);

%normalize to average b0 image
for i = 1:size(data, 1)
    data(i, :) = data(i, :) ./ b0;  
end

% load phase distributions and set acquisition parameters
global generic
generic = load('generic_v2.mat');
generic.('T') = T;
generic.('b') = b;
generic.('betta') = betta;
generic.('Db') = ones(size(b)) * 1.6;

%initialize variables for pixelwise fit results
Dhighb = zeros(1, size(data, 2));
fhighb = zeros(1, size(data, 2));
D = zeros(1, size(data, 2));
f = zeros(1, size(data, 2));
Dstar = zeros(1, size(data, 2));
tau = zeros(1, size(data, 2));
r = zeros(1, size(data, 2));
v = zeros(1, size(data, 2));

% selector for high b values and bipolar gradients
biphighb = ((b >= 200) & (betta == 1));
options = optimset('Display', 'off');

tic
for i = 1:size(data, 2)
    
    [param(1:2), ~] = fminsearch(@(x) norm(data(biphighb, i) - (1-x(2))*exp(-b(biphighb) * x(1) / 1000))^2, [0.2, 2], options);
    %lb = [0, 0];
    %ub = [4, 1];
    %param(1:2) = lsqnonlin(@(x) (data(biphighb, i) - (1-x(2))*exp(-b(biphighb) * x(1) / 1000)), [0.2, 2], lb, ub, options);
    Dhighb(i) = param(1);
    fhighb(i) = param(2);
    [param(3:6), param(7)] = fminsearch(@(x) norm(data(:, i) - generic_model(x))^2, [param(1:2), 2, 4], options);
    %lb = [0, 0, 1/100, 0];
    %ub = [4, 1, 1599/100, 1000];
    %[param(3:6), param(7)] = lsqnonlin(@(x) data(:, i) - generic_model(x), [param(1:2), 2, 4], lb, ub, options);
    D(i) = param(3);
    f(i) = param(4);
    tau(i) = param(5) * 100;
    v(i) = param(6);
    Dstar(i) = tau(i) *  v(i) * v(i) / 6;
    r(i) = param(7);
    
    waitbar(i / size(data, 2))
end
toc

temp = zeros(size(mask));
temp(mask > 0) = b0;
b0 = temp;
temp(mask > 0) = D;
D = temp;
temp(mask > 0) = f;
f = temp;
temp(mask > 0) = r;
r = temp;
temp(mask > 0) = v;
v = temp;
temp(mask > 0) = Dstar;
Dstar = temp;
temp(mask > 0) = tau;
tau = temp;
temp(mask > 0) = Dhighb;
Dhighb = temp;
temp(mask > 0) = fhighb;
fhighb = temp;
clear lb_highb ub_highb lb ub options1 highbdata highb


save(['Result'], 'b0', 'D', 'f', 'tau', 'v', 'Dstar', 'Dhighb', 'fhighb', 'r');


        figure('NumberTitle', 'off', 'Name', strcat('IVIM_','Slice_',num2str(slice),'_grey'));
        subplot(3,3,1);
        imshow(b0,'DisplayRange',[]),title('b0');
        subplot(3,3,2);
        imshow(D,'DisplayRange',[]),title('D');
        subplot(3,3,3);
        imshow(f,'DisplayRange',[]),title('f');
        subplot(3,3,4);
        imshow(tau,'DisplayRange',[]),title('tau');
        subplot(3,3,5);
        imshow(v,'DisplayRange',[]),title('v');
        subplot(3,3,6);
        imshow(Dstar,'DisplayRange',[]),title('Dstar');
        subplot(3,3,7);
        imshow(Dhighb,'DisplayRange',[]),title('Dhighb');
        subplot(3,3,8);
        imshow(fhighb,'DisplayRange',[]),title('fhighb');
        subplot(3,3,9);
        imshow(r,'DisplayRange',[]),title('r');
        
 figure('NumberTitle', 'off', 'Name', strcat('IVIM_','Slice_',num2str(slice),'_color'));
        subplot(3,3,1);
        imagesc(b0),title('b0');
        subplot(3,3,2);
        imagesc(D),title('D');
        subplot(3,3,3);
        imagesc(f),title('f');
        subplot(3,3,4);
        imagesc(tau),title('tau');
        subplot(3,3,5);
        imagesc(v),title('v');
        subplot(3,3,6);
        imagesc(Dstar),title('Dstar');
        subplot(3,3,7);
        imagesc(Dhighb),title('Dhighb');
        subplot(3,3,8);
        imagesc(fhighb),title('fhighb');
        subplot(3,3,9);
        imagesc(r),title('r');

       