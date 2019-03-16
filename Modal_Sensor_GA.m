%---------------------------------------------------------------------------------
% Source code for generating Modal GA Sensor with random noise and GPU acceleration
% Copyright 2018 Weisong Zhao
%----------------------------------------------------------------------------------
clc
clear all
close all
%%
lamda=532*10^-9;
sin1=0.4;
sin2=sin(asin(sin1)/2)^2;
z=0;
u=8*pi*z*sin1/lamda;
Iimage=imread('1.jpg');
image1=double(Iimage(:,:,1));
[imgx,imgy]=size(image1);
a_parameter=[0.125682544377515,0.905791937075619,-0.126986816293506,-0.913375856139019,0.632359246225410,-0.097540404999410,0.278498218867048,-3.246881519204984,...
    0.957506835434298,-0.964888535199277,-0.157613081677548,-0.970592781760616,0.357166948242946,0.485375648722841,-0.800280468888800,0.141886338627215,0.421761282626275,...
    -0.915735525189067,4.292207329559554]./3;
%%
T=500;%iteration times
N=10;% group size
pc=0.8;pm=0.05;%Crossover mutation probability
umax=1;umin=-1;%range of parameter to optim.
L1=19;%number
L2=8;%single length
L=L1*L2;%Total coding length L
bval=round(rand(N,L));
bestv=-inf;%
for ii=1:1:T
    ii
    %%%%%%%%%%%%½âÂë
    for i=1:1:N
        y1=zeros(N,L1);
        x=zeros(N,L1);
        for ll=1:1:L1
            
            for j=(ll-1)*L2+1:1:ll*L2
                
                y1(i,ll)=y1(i,ll)+bval(i,j)*2^(-j+L2*ll);
                
            end
            x(i,ll)=(umax-umin)*y1(i,ll)/(2^L2-1)+umin;
            
            
        end
        a=a_parameter-x(i,:);
        PSF=PSF_with_Aberration(a);
        chushi=conv2(image1,PSF,'same');
        chushi=abs(chushi.^2);
        chushi=chushi+40000000*randn(imgx,imgy);
        chushi=255*chushi./max(max(chushi));
        M1=aberration(chushi);
        obj(i)=M1;
        xx(i,:)=x(i,:);
    end
    func=obj;
    p=func./sum(func);
    q=cumsum(p);
    [fmax,indmax]=max(func);
    if fmax>=bestv
        bestv=fmax;
        bvalxx=bval(indmax,:);
        optxx=xx(indmax,:);
    end
    Best(ii)=fmax;
    Bfit1(ii)=bestv; 
    %%%%
    %Roulette selection
    % newbval=zeros(N,L);
    for i=1:N
        r=rand;
        %  if q(:)>=r
        tmp=find(r<=q);
        newbval(i,:)=bval(tmp(1),:);
        %  end
    end
    % newbval(N,:)=bvalxx;%
    bval=newbval;
   
    for i=1:2:(N-1)
        cc=rand;
        if cc<pc
            point=ceil(rand*(L-1));
            ch=bval(i,:);
            bval(i,point+1:L)=bval(i+1,point+1:L);
            bval(i+1,point+1:L)=ch(1,point+1:L);
        end
        
    end
    % bval(N,:)=bvalxx;%
    %Locus variation 
    for i=1:N
        for j=1:(L)
            pb=rand;
            if(pb<pm)
                bval(i,j)=1-bval(i,j);
            end
        end
    end
    if bestv>72
        break
    end
    
end

%%
optxx
bestv
a=a_parameter-optxx;
PSF=PSF_with_Aberration(a);
zuiyou=conv2(image1,PSF,'same');
zuiyou=abs(zuiyou.^2);
zuiyou=zuiyou+40000000*randn(imgx,imgy);
zuiyou=255*zuiyou./max(max(zuiyou));
M1=aberration(zuiyou);
%%
figure(1)
imshow(zuiyou./255)
figure(2)
plot(Best,'LineWidth',1.5);% Optimal fitness evolution curve 
hold on
plot(Bfit1,'k','LineWidth',1.5);% Optimal fitness evolution curve 
imwrite(zuiyou./max(max(zuiyou)),'GA.bmp');
save Best.mat Best*
save Bfit1.mat Bfit1*
save optxx.mat optxx*