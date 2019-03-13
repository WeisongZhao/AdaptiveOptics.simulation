function M=aberration(image)

I=image;
[m,n]=size(I);
Imean=mean(mean(I));
I1=I-Imean;
I2=I1.^2;
Isum=sum(sum(I2));
M=sqrt(Isum/(m*n));