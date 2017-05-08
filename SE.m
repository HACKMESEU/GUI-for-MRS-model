
function [DDC,a] = SE(data,b,mask,row,column)

b0 = 0; %The postion of b = 0;
for i =1:length(b)
    if (b(i) ==0)
  %      figure,imshow(data(:,:,i), 'DisplayRange',[]),title('DWI b=0');
        b0 = i;
    end
end

if(b0==0)
    msgbox('The data should include b value equals 0!');
else
%     for i =1:length(b)
%         if (b(i) > 0)
%             ADC = (log(single(data(:,:,i))./single(data(:,:,b0))))/(-b(i));  %caculate the ADC value: ADC = ln(Sb/S0)/(-b)
%             figure,imagesc(ADC),colorbar,title('ADC value map');
%             break
%         end
%     end
    % Initialize the DDC and a maps.
    DDC = single(zeros(row,column)); 
    a = single(zeros(row,column));
    y = b(2:length(b));
    for i = 1:row
        for j = 1:column
            % caculate the DDC & a value:
            % Sb/S0 = exp(-(bDDC)^a);
            % using multipoint analysis with the full set of b values(10,20,50,100,200,500,1000).
            % A = ln(-ln(Sb/s0)); B  = -1 ;C =ln(b)
            % x1 = 1/a;x2 = ln(DDC)
            % caculate the x1 and x2 in the equation A*x1+B*x2 = C.
            if(mask(i,j))
                nonzero = 1;
                for t = 1:length(b)
                    if(data(i,j,t) == 0)
                        nonzero = 0;
                    end
                end
                
                if(nonzero)                     % Determine if any image value equals zero.
                    
                    A = [];
                    for z = 1:length(b)
                        if(z == b0)
                        else
                            A = [A;log(-log(single(data(i,j,z))/single(data(i,j,b0))))];
                        end
                    end
%                     A = [log(-log(single(I_B10(i,j))/single(I_B0(i,j))));
%                         log(-log(single(I_B20(i,j))/single(I_B0(i,j))));
%                         log(-log(single(I_B50(i,j))/single(I_B0(i,j))));
%                         log(-log(single(I_B100(i,j))/single(I_B0(i,j))));
%                         log(-log(single(I_B200(i,j))/single(I_B0(i,j))));
%                         log(-log(single(I_B500(i,j))/single(I_B0(i,j))));
%                         log(-log(single(I_B1000(i,j))/single(I_B0(i,j))))];
                    B = zeros(length(b)-1,1)-1;
                    C = log(1.*(y'));
                    temp = [A,B];
                    x = (temp'*temp)\(temp'*C);    %solve regulazation equation
                else
                    x = [0;0];
                end
                a(i,j) = 1/x(1);
                DDC(i,j) = exp(x(2));

                % The values of DDC and a have range.
                if(1/x(1)>1|1/x(1)<-1)
                    a(i,j) = 1;
                else a(i,j) = 1/x(1);
                end
                if(exp(x(2))>1e-2|exp(x(2))<-1e-2)
                    DDC(i,j) = 0;
                else
                DDC(i,j) = exp(x(2));
                end
            else
                a(i,j) = 0; DDC(i,j) = 0;
            end

        end
    end
    a = real(a);
    DDC = real(DDC);
    %figure,imagesc(real(a)),colorbar,title('a value map');
    %figure,imagesc(real(DDC)),colorbar,title('DDC value map');
end







% tic
% for i=top:bottom
%     for j = left:right
%         % using a nonlinear leastsquares routine
%         % Sb/S0 = exp((-b*DDC)^a)
%         % y = Sb/S0;x=b;
%         if(double(I_B0(i,j)))
%             ydata = [double(I_B10(i,j))/double(I_B0(i,j)),double(I_B20(i,j))/double(I_B0(i,j)),double(I_B50(i,j))/double(I_B0(i,j)),double(I_B100(i,j))/double(I_B0(i,j)),double(I_B200(i,j))/double(I_B0(i,j)),double(I_B500(i,j))/double(I_B0(i,j)),double(I_B1000(i,j))/double(I_B0(i,j))];
%             xdata = [10 20 50 100 200 500 1000];
%             lb = [-1e-2,0];     %    0<a<1
%             ub = [1e-2,1];  % 0<DDC<1e-2
%             fun = @(x,xdata)exp(power(-x(1)*xdata,x(2)));
%             x0 = [-1e-2,1];
%             x = lsqcurvefit(fun,x0,xdata,ydata,lb,ub);
%             I_a(i,j) = x(2);
%             I_DDC(i,j) = x(1);  
%         else
%             I_a(i,j) = 0;
%             I_DDC(i,j) = 0;
%         end
%         if (I_a(i,j)<0) I_a(i,j)=0;
%         elseif (I_a(i,j)>1) I_a(i,j)=1;
%         end
%         if (I_DDC(i,j)<-1e-2) I_DDC(i,j)=-1e-2;
%         elseif (I_DDC(i,j)>1e-2) I_DDC(i,j)=1e-2;
%         end
%     end
% end
% toc
%figure(3),imshow(I_ADC, 'DisplayRange',[]);





%     for i = 1:length(filelist)
%         info = dicominfo([DicomFolder '/' filelist(i).name]);
%         Bvalue = info.DiffusionBValue;
%         filename = info.Filename;
%         switch Bvalue
%             case 0
%                 B0_file = [B0_file;filename];
%             case 10
%                 B10_file = [B10_file;filename];
%             case 20
%                 B20_file = [B20_file;filename];
%             case 50
%                 B50_file = [B50_file;filename];
%             case 100
%                 B100_file = [B100_file;filename];
%             case 200
%                 B200_file = [B200_file;filename];
%             case 500
%                 B500_file = [B500_file;filename];
%             case 1000
%                 B1000_file = [B1000_file;filename];
%             case 2000
%                 B2000_file = [B2000_file;filename];
%         end
%     end
   