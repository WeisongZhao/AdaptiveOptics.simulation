function IP1=PSF_with_Aberration2(pixel,lamda,NA,n,a)
%-----------------------------------------------
%Source code for generating PSF
%pixel     pixel size {example:65*10^-9}
%lamda   wavelength {example:532*10^-9}
%NA        NA {example:1.49}
%n          number of psf {example:64}
%a          Coefficients of Zenick Polynomials {it should be a {1,19} array}
%------------------------------------------------
%Output:
% Ipsf    PSF
%-------------------------------------------------------------------------------------
%   Copyright  2018 Weisong Zhao "Accurate aberration correction in confocal
%   microscopy based on modal sensorless method"Rev. Sci. Instrum.
%   90, 053703 (2019); https://doi.org/10.1063/1.5088102
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <http://www.gnu.org/licenses/>.
%-------------------------------------------------------------------------------------
%%
sin2=((1-(1-NA^2))/2);
I0=@(r,p,theta) 2*besselj(0,(2*pi*r*sin2/lamda).*p).*exp(1i*(a(1)*(sqrt(3)*(2*p.^2-1))+a(2)*(sqrt(6)*(p.^2).*cos(2*theta))+a(3)*(sqrt(6)*(p.^2).*sin(2*theta))+...
    a(4)*(2*sqrt(2)*(3*p.^2-2*p).*cos(theta))+a(5)*(2*sqrt(2)*(3*p.^2-2*p).*sin(theta))+...
    a(6)*(2*sqrt(2)*(p.^3).*cos(3*theta))+a(7)*(2*sqrt(2)*(p.^3).*sin(3*theta))+...
    a(8)*(sqrt(5)*(6*p.^4-6*p.^2+1))+a(9)*(sqrt(10)*(4*p.^4-3*p.^2).*cos(2*theta))+...
    a(10)*(sqrt(10)*(4*p.^4-3*p.^2).*sin(2*theta))+a(11)*(sqrt(10)*(p.^4).*cos(4*theta))+...
    a(12)*(sqrt(10)*(p.^4).*cos(4*theta))+a(13)*(2*sqrt(3)*(10*p.^5-12*p.^3+3*p).*cos(theta))+...
    a(14)*(2*sqrt(3)*(10*p.^5-12*p.^3+3*p).*sin(theta))+a(15)*(2*sqrt(3)*(5*p.^5-4*p.^3).*cos(3*theta))+...
    a(16)*(2*sqrt(3)*(5*p.^5-4*p.^3).*sin(3*theta))+a(17)*(2*sqrt(3)*(p.^5).*cos(5*theta))+...
    a(18)*(2*sqrt(3)*(p.^5).*sin(5*theta))+a(19)*(sqrt(7)*(20*p.^6-30*p.^4+12*p.^2-1))));
x=-n*pixel:pixel:n*pixel;
[X,Y]=meshgrid(x,x);
[~,s1]=cart2pol(X,Y);
idx=s1<=1;
IP0=zeros(size(X));
k=1;
IP=gpuArray(IP0);
for f=1:1:size(s1)
    for j=1:1:size(s1)
        if idx(f,j)==0
            IP(f,j)=0;
        else
            o=s1(idx);
            r=o(k);
            k=k+1;
            II=@(p,theta)I0(r,p,theta);
            IP(f,j)=integral2(II,0,1,0,2*pi);
        end
    end
end
IP1=gather(IP);
IP1=abs(IP1.^2);