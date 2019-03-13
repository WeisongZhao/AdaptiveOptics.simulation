function M=aberration2(obj_pre)     
II2=obj_pre.^2;
       
Iz2=sum(sum(obj_pre));
       
IIz2=sum(sum(II2));
       
M=(Iz2^2)/IIz2;
%