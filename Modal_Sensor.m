%---------------------------------------------------------------------------------
% Source code for generating Modal Sensor 2N+1/4N+1 with random noise
% Copyright 2017 Weisong Zhao
%----------------------------------------------------------------------------------
clc
clear all
close all
%% Parameters
N=5;
% Zero=1;
bias=0.55;
lamda=532*10^-9;
sin1=0.4;
sin2=sin(asin(sin1)/2)^2;
z=0;
u=8*pi*z*sin1/lamda;
Iimage=imread('1.jpg');
image1=double(Iimage(:,:,1));
[a00,b00]=size(image1);
noise=randn(a00,b00)*40000000;
% noise=zeros(a00,b00);
a_parameter=[0.125682544377515,0.905791937075619,-0.126986816293506,-0.913375856139019,0.632359246225410,-0.097540404999410,0.278498218867048,-3.246881519204984,...
    0.957506835434298,-0.964888535199277,-0.157613081677548,-0.970592781760616,0.357166948242946,0.485375648722841,-0.800280468888800,0.141886338627215,0.421761282626275,...
    -0.915735525189067,4.292207329559554]./3;
a_parameter(1)=0;
%% No aberration£¬chushi: image M_clear: var
a=zeros(1,19);
PSF=PSF_with_Aberration(a);
Original=conv2(image1,PSF,'same');
Original=abs(Original.^2);
Original=Original+noise;
Original=255*Original./max(max(Original));
M_clear1=aberration(Original);
M_clear2=aberration2(Original);
M_clear3=aberration3(Original);
M_clear4=aberration4(Original);
imwrite(Original/max(max(Original)),'AO\4N+1-noise\Noaberration+noise.bmp')
%% With initial aberration, ZONG0, M0
a=a_parameter;
PSF=PSF_with_Aberration(a);
Total0=conv2(image1,PSF,'same');
Total0=abs(Total0.^2);
Total0=Total0+noise;
[a01,b01]=size(Total0);
Total0=255*Total0./max(max(Total0));
imwrite(Total0/max(max(Total0)),'AO\4N+1-noise\WithAberration+noise.bmp')
M01=aberration(Total0);
M02=aberration2(Total0);
M03=aberration3(Total0);
M04=aberration4(Total0);
%% Circle%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for pp=1:1:19
    a=a_parameter;
    pp
    if N==5
        noise=randn(a00,b00)*40000000;
    elseif N==3&& mod(pp,2)==0
        noise=randn(a00,b00)*40000000;
    end
    %% b
    a(pp)=a(pp)+bias;
    PSF=PSF_with_Aberration(a);
    Total=conv2(image1,PSF,'same');
    Total=abs(Total.^2);
    Total=Total+noise;
    Total=255*Total./max(max(Total));
    ii=int2str(pp+3);
    imwrite(Total/max(max(Total)),['AO\4N+1-noise\',ii,'Orderpositive.bmp']);
    M21=aberration(Total);
    M22=aberration2(Total);
    M23=aberration3(Total);
    M24=aberration4(Total);
    M21_sum(pp)=M21;
    M22_sum(pp)=M22;
    M23_sum(pp)=M23;
    M24_sum(pp)=M24;
    %% -b
    a=a_parameter;
    a(pp)=a(pp)-bias;
    PSF=PSF_with_Aberration(a);
    ZONG1=conv2(image1,PSF,'same');
    ZONG1=abs(ZONG1.^2);
    ZONG1=ZONG1+noise;
    ZONG1=255*ZONG1./max(max(ZONG1));
    imwrite(ZONG1/max(max(ZONG1)),['AO\4N+1-noise\',ii,'Ordernegtive.bmp']);
    M11=aberration(ZONG1);
    M12=aberration2(ZONG1);
    M13=aberration3(ZONG1);
    M14=aberration4(ZONG1);
    M11_sum(pp)=M11;
    M12_sum(pp)=M12;
    M13_sum(pp)=M13;
    M14_sum(pp)=M14;
    %%
    if N==5
        %% -2/b
        a=a_parameter;
        a(pp)=a(pp)-bias/2;
        PSF=PSF_with_Aberration(a);
        ZONG10=conv2(image1,PSF,'same');
        ZONG10=abs(ZONG10.^2);
        ZONG10=ZONG10+noise;
        ZONG10=255*ZONG10./max(max(ZONG10));
        imwrite(ZONG10/max(max(ZONG10)),['AO\4N+1-noise\',ii,'Ordernegtive0.5.bmp']);
        M101=aberration(ZONG10);
        M102=aberration2(ZONG10);
        M103=aberration3(ZONG10);
        M104=aberration4(ZONG10);
        M101_sum(pp)=M101;
        M102_sum(pp)=M102;
        M103_sum(pp)=M103;
        M104_sum(pp)=M104;
        %% 2/b
        a=a_parameter;
        a(pp)=a(pp)+bias/2;
        PSF=PSF_with_Aberration(a);
        Total2=conv2(image1,PSF,'same');
        Total2=abs(Total2.^2);
        Total2=Total2+noise;
        Total2=255*Total2./max(max(Total2));
        ii=int2str(pp+3);
        imwrite(Total2/max(max(Total2)),['AO\4N+1-noise\',ii,'Orderpositive0.5.bmp']);
        M021=aberration(Total2);
        M022=aberration2(Total2);
        M023=aberration3(Total2);
        M024=aberration4(Total2);
        M021_sum(pp)=M021;
        M022_sum(pp)=M022;
        M023_sum(pp)=M023;
        M024_sum(pp)=M024;
    end
    %% FIGURE
    % figure(1)
    % subplot 121
    % imshow(ZONG./max(max(ZONG)))
    % subplot 122
    % imshow(ZONG1./max(max(ZONG1)))
    %% Calculate a N=5;
    if N==5
        % a01=[M_clear1,0.5,(bias-0.5)^2/log(M_clear1/M01)];
        % a02=[M_clear2,0.5,(bias-0.5)^2/log(M_clear2/M02)];
        % a03=[M_clear3,0.5,(bias-0.5)^2/log(M_clear3/M03)];
        % a04=[M_clear4,0.5,(bias-0.5)^2/log(M_clear4/M04)];
        a01=[M_clear1,M_clear1-M01,0.7];
        a02=[M_clear2,M_clear2-M02,0.7];
        a03=[M_clear3,M_clear3-M03,0.7];
        a04=[M_clear4,M_clear4-M04,0.7];
        x0=[-bias,-bias/2,0,bias/2,bias];
        y1=[M11,M101,M01,M021,M21];
        y2=[M12,M102,M02,M022,M22];
        y3=[M13,M103,M03,M023,M23];
        y4=[M14,M104,M04,M024,M24];
        s1=lsqcurvefit('fun',a01,x0,y1);
        s2=lsqcurvefit('fun',a02,x0,y2);
        s3=lsqcurvefit('fun',a03,x0,y3);
        s4=lsqcurvefit('fun',a04,x0,y4);
        C_51(pp)=s1(3);
        C_52(pp)=s2(3);
        C_53(pp)=s3(3);
        C_54(pp)=s4(3);
        %Poly fit
        % s11=polyfit(x0,y1,2);
        % s22=polyfit(x0,y2,2);
        % s33=polyfit(x0,y3,2);
        % s44=polyfit(x0,y4,2);
        % xy=-2:0.0001:2;
        % ss1=s11(1)*xy.^2+s11(2)*xy+s11(3);
        % ss2=s22(1)*xy.^2+s22(2)*xy+s22(3);
        % ss3=s33(1)*xy.^2+s33(2)*xy+s33(3);
        % ss4=s44(1)*xy.^2+s44(2)*xy+s44(3);
        % s01=find(ss1==min(ss1));
        % s01=s01*0.0001-2;
        % s02=find(ss2==min(ss2));
        % s02=s02*0.0001-2;
        % s03=find(ss3==min(ss3));
        % s03=s03*0.0001-2;
        % s04=find(ss4==max(ss4));
        % s04=s04*0.0001-2;
        % C_51(pp)=s01;
        % C_52(pp)=s02;
        % C_53(pp)=s03;
        % C_54(pp)=s04;
    end
    %%  Calculate a N=3;
    if N==3
        C1(pp)=-(bias*(M21-M11))/(2*M21-4*M01+2*M11);
        C2(pp)=-(bias*(M22-M12))/(2*M22-4*M02+2*M12);
        C3(pp)=-(bias*(M23-M13))/(2*M23-4*M03+2*M13);
        C4(pp)=-(bias*(M24-M14))/(2*M24-4*M04+2*M14);
    end
end
%% Save Mat
if N==5
    Result1(:,1)=M11_sum;
    Result1(:,2)=M101_sum;
    Result1(:,3)=M021_sum;
    Result1(:,4)=M21_sum;
    Result1(:,5)=C_51;
    Result1(1,6)=M_clear1;
    Result1(2,6)=M01;
    Result2(:,1)=M12_sum;
    Result2(:,2)=M102_sum;
    Result2(:,3)=M022_sum;
    Result2(:,4)=M22_sum;
    Result2(:,5)=C_52;
    Result2(1,6)=M_clear2;
    Result2(2,6)=M02;
    Result3(:,1)=M13_sum;
    Result3(:,2)=M103_sum;
    Result3(:,3)=M023_sum;
    Result3(:,4)=M23_sum;
    Result3(:,5)=C_53;
    Result3(1,6)=M_clear3;
    Result3(2,6)=M03;
    Result4(:,1)=M14_sum;
    Result4(:,2)=M104_sum;
    Result4(:,3)=M024_sum;
    Result4(:,4)=M24_sum;
    Result4(:,5)=C_54;
    Result4(1,6)=M_clear4;
    Result4(2,6)=M04;
elseif N==3
    Result1(:,1)=M11_sum;
    Result1(:,2)=M21_sum;
    Result1(:,3)=C1;
    Result1(1,4)=M_clear1;
    Result1(2,4)=M01;
    Result2(:,1)=M12_sum;
    Result2(:,2)=M22_sum;
    Result2(:,3)=C2;
    Result2(1,4)=M_clear2;
    Result2(2,4)=M02;
    Result3(:,1)=M13_sum;
    Result3(:,2)=M23_sum;
    Result3(:,3)=C3;
    Result3(1,4)=M_clear3;
    Result3(2,4)=M03;
    Result4(:,1)=M14_sum;
    Result4(:,2)=M24_sum;
    Result4(:,3)=C4;
    Result4(1,4)=M_clear4;
    Result4(2,4)=M04;
end
%%  Correct %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if N==3
    C(:,1)=C1;C(:,2)=C2;C(:,3)=C3;C(:,4)=C4;C=C';
elseif N==5
    C5(:,1)=C_51;C5(:,2)=C_52;C5(:,3)=C_53;C5(:,4)=C_54;C5=C5';
end
%% Reduce
for l=1:4
    a=a_parameter;
    if N==5
        C5(C5>2)=0;
        C5(C5<-2)=0;
        a=a-C5(l,:);
    elseif N==3
        C(C>2)=0;
        C(C<-2)=0;
        a=a-C(l,:);
    end
    a(1)=0;
    PSF=PSF_with_Aberration(a);
    Correction=conv2(image1,PSF,'same');
    Correction=abs(Correction.^2);
    Correction=255*Correction./max(max(Correction));
    if l==1
        M_correct(l)=aberration(Correction);
    elseif l==2
        M_correct(l)=aberration2(Correction);
    elseif l==3
        M_correct(l)=aberration3(Correction);
    elseif l==4
        M_correct(l)=aberration4(Correction);
    end
    ll=int2str(l);
    imwrite(Correction/max(max(Correction)),['AO\4N+1-noise\',ll,'SUB+Noise.bmp'])
end
if N==3
    Result1(3,4)=M_correct(1);
    Result2(3,4)=M_correct(2);
    Result3(3,4)=M_correct(3);
    Result4(3,4)=M_correct(4);
elseif N==5
    Result1(3,6)=M_correct(1);
    Result2(3,6)=M_correct(2);
    Result3(3,6)=M_correct(3);
    Result4(3,6)=M_correct(4);
end
%% Add
for l=1:4
    a=a_parameter;
    if N==5
        a=a+C5(l,:);
    elseif N==3
        a=a+C(l,:);
    end
    a(1)=0;
    PSF=PSF_with_Aberration(a);
    Correction=conv2(image1,PSF,'same');
    Correction=abs(Correction.^2);
    Correction=255*Correction./max(max(Correction));
    [a01,b01]=size(Correction);
    if l==1
        M_correct2(l)=aberration(Correction);
    elseif l==2
        M_correct2(l)=aberration2(Correction);
    elseif l==3
        M_correct2(l)=aberration3(Correction);
    elseif l==4
        M_correct2(l)=aberration4(Correction);
    end
    ll=int2str(l);
    imwrite(Correction/max(max(Correction)),['AO\4N+1-noise\',ll,'ADD+Noise.bmp'])
end
if N==3
    Result1(4,4)=M_correct2(1);
    Result2(4,4)=M_correct2(2);
    Result3(4,4)=M_correct2(3);
    Result4(4,4)=M_correct2(4);
elseif N==5
    Result1(4,6)=M_correct2(1);
    Result2(4,6)=M_correct2(2);
    Result3(4,6)=M_correct2(3);
    Result4(4,6)=M_correct2(4);
end
save AO\4N+1-noise\Result1.mat Result1*
save AO\4N+1-noise\Result2.mat Result2*
save AO\4N+1-noise\Result3.mat Result3*
save AO\4N+1-noise\Result4.mat Result4*

