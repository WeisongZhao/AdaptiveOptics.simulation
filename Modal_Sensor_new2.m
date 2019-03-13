%---------------------------------------------------------------------------------
% 2.Source code for generating Modal Sensor +-0.7rad the second circle with random noise and GPU acceleration
% Copyright 2017 Weisong Zhao
%----------------------------------------------------------------------------------
clc
clear all
close all
%% Parameters
bias=0.7;
lamda=532*10^-9;
sin1=0.4;
sin2=sin(asin(sin1)/2)^2;
z=0;
u=8*pi*z*sin1/lamda;
Iimage=imread('1.jpg');
image1=double(Iimage(:,:,1));
[a00,b00]=size(image1);
noise=randn(a00,b00)*40000000;
a_parameter=[0.125682544377515,0.905791937075619,-0.126986816293506,-0.913375856139019,0.632359246225410,-0.097540404999410,0.278498218867048,-3.246881519204984,...
    0.957506835434298,-0.964888535199277,-0.157613081677548,-0.970592781760616,0.357166948242946,0.485375648722841,-0.800280468888800,0.141886338627215,0.421761282626275,...
    -0.915735525189067,4.292207329559554]./3;
load('AO\4N+1-noise\Result.mat')
first=Result(4,:);
a_parameter=a_parameter+first;
%% No aberration£¬chushi: image M_clear: var 
a=zeros(1,19);
IP1=PSF_with_Aberration(a);
chushi=conv2(image1,IP1,'same');
chushi=abs(chushi.^2);
chushi=chushi+noise;
chushi=255*chushi./max(max(chushi));
M_clear1=aberration(chushi);
M_clear2=aberration2(chushi);
M_clear3=aberration3(chushi);
M_clear4=aberration4(chushi);
imwrite(chushi/max(max(chushi)),'AO\4N+1-noise\NoAberration+noise.bmp')
%% Circle%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for pp=1:1:19
a=a_parameter;
pp
if mod(pp,2)==0
    noise=randn(a00,b00)*40000000;
end
%% With initial aberration, ZONG0, M0
a=a_parameter;
IP1=PSF_with_Aberration(a);
ZONG0=conv2(image1,IP1,'same');
ZONG0=abs(ZONG0.^2);
ZONG0=ZONG0+noise;
[a01,b01]=size(ZONG0);
ZONG0=255*ZONG0./max(max(ZONG0));
ii=int2str(pp+3);
imwrite(ZONG0/max(max(ZONG0)),['AO\4N+1-noise\',ii,'WithAberration.bmp'])
M01_sum(pp)=aberration(ZONG0);
%% b
a=a_parameter;
a(pp)=a(pp)+bias;
IP1=PSF_with_Aberration(a);
ZONG=conv2(image1,IP1,'same');
ZONG=abs(ZONG.^2);
ZONG=ZONG+noise;
ZONG=255*ZONG./max(max(ZONG));
imwrite(ZONG/max(max(ZONG)),['AO\4N+1-noise\',ii,'orderPositive.bmp']);
M21=aberration(ZONG);
M21_sum(pp)=M21;

%% -b
a=a_parameter;
a(pp)=a(pp)-bias;
IP1=PSF_with_Aberration(a);
ZONG1=conv2(image1,IP1,'same');
ZONG1=abs(ZONG1.^2);
ZONG1=ZONG1+noise;
ZONG1=255*ZONG1./max(max(ZONG1));
imwrite(ZONG1/max(max(ZONG1)),['AO\4N+1-noise\',ii,'orderNegative.bmp']);
M11=aberration(ZONG1);
M11_sum(pp)=M11;
if M11>=M21&&M11>=M01_sum(pp)  
    M(pp)=-0.7;
elseif M21>=M11&&M21>=M01_sum(pp)     
    M(pp)=0.7;             
else    
    M(pp)=0;
end
end
Result(1,:)=M11_sum;
Result(2,:)=M01_sum;
Result(3,:)=M21_sum;
Result(4,:)=M;
save AO\4N+1-noise\Result.mat Result*  


