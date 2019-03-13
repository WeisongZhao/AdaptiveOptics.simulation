%---------------------------------------------------------------------------------
% 3.Source code for generating SPGD with random noise and GPU acceleration
% Copyright 2017 Weisong Zhao
%----------------------------------------------------------------------------------
clc
clear all
close all
%% Parameters
rate=50;
iterations=300;
lamda=532*10^-9;
sin1=0.4;
sin2=sin(asin(sin1)/2)^2;
z=0;
u=8*pi*z*sin1/lamda;
Iimage=imread('1.jpg');
image1=double(Iimage(:,:,1));
[a01,b01]=size(image1);
noise=randn(a01,b01)*40000000;
a_parameter=[0.125682544377515,0.905791937075619,-0.126986816293506,-0.913375856139019,0.632359246225410,-0.097540404999410,0.278498218867048,-3.246881519204984,...
    0.957506835434298,-0.964888535199277,-0.157613081677548,-0.970592781760616,0.357166948242946,0.485375648722841,-0.800280468888800,0.141886338627215,0.421761282626275,...
    -0.915735525189067,4.292207329559554]./3;
a_parameter(1)=0;
a2=a_parameter.^2;
suma=sqrt(sum(a2));
%% No aberration£¬chushi: image M_clear: var 
PSF=PSF_with_Aberration(a);
initial=conv2(image1,PSF,'same');
initial=abs(initial.^2);
initial=initial+noise;
initial=255*initial./max(max(initial));
M_clear1=aberration(initial);
imwrite(initial/max(max(initial)),'AO\4N+1-noise\NoAberration+noise.bmp')
clear IP IP1 a
for iteration=1:iterations
%% Circle%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
iteration
noise=randn(a01,b01)*40000000;
bias=zeros(1,19);
%% b
a=a_parameter;
a=a+bias;
PSF=PSF_with_Aberration(a);
Total=conv2(image1,PSF,'same');
Total=abs(Total.^2);
% ZONG=255*ZONG./max(max(ZONG));
Total=Total+noise;
Total=255*Total./max(max(Total));
M21=aberration(Total);
%% -b
a=a_parameter;
a=a-bias;
PSF=PSF_with_Aberration(a);
Total1=conv2(image1,PSF,'same');
Total1=abs(Total1.^2);
% ZONG1=255*ZONG1./max(max(ZONG1));
Total1=Total1+noise;
Total1=255*Total1./max(max(Total1));
M11=aberration(Total1);
%% Save Mat
a_parameter=a_parameter+bias*rate*(M21-M11);
a=a_parameter;
PSF=PSF_with_Aberration(a);
Total2=conv2(image1,PSF,'same');
Total2=abs(Total2.^2);
Total2=255*Total2./max(max(Total2));
ii=int2str(iteration);
imwrite(Total2/max(max(Total2)),['AO\4N+1-noise\',ii,'iter.bmp']);
M_result=aberration(Total2)   
Result(1,iteration)=M21;
Result(2,iteration)=M11;
Result(3,iteration)=M_result;
Result(iteration+1,1:19)=a_parameter;
if M_result>=71
    break
end
end
save AO\4N+1-noise\Result.mat Result*  