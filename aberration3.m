function M=aberration3(ZONG)
I3=ZONG;
[m,n]=size(I3(:,:,1));
for i=1:1:m
    for j=1:1:n
        if (i==1||i==m)
            IX3(i,j)=I3(i,j);
            IY3(i,j)=I3(i,j);
        elseif (j==1||j==n)
            IX3(i,j)=I3(i,j);
            IY3(i,j)=I3(i,j);
        else
            IX3(i,j)=(-1)*I3(i-1,j-1)+(-2)*I3(i-1,j)+(-1)*I3(i-1,j+1)+I3(i+1,j-1)+2*I3(i+1,j)+I3(i+1,j+1);
            IY3(i,j)=(-1)*I3(i-1,j-1)+I3(i-1,j+1)+(-1)*I3(i+1,j-1)+I3(i+1,j+1)+(-2)*I3(i,j-1)+2*I3(i,j+1);
        end
    end
end
II3=sqrt(IX3.^2+IY3.^2);
M=sum(sum(II3))/sum(sum(I3));