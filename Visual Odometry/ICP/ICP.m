function [R,t]=ICP(Point3ddepth_1,Point3dP3P_2)
%UNTITLED4 ICP算法，奇异值矩阵分解
%   利用奇异值矩阵分解求解Rt。
%作者：陈斌豪
P1=Point3ddepth_1-sum(Point3ddepth_1)/length(Point3ddepth_1);   %计算去质心坐标
P1c=sum(Point3ddepth_1)/length(Point3ddepth_1);                 %计算质心坐标
P2=Point3dP3P_2-sum(Point3dP3P_2)/length(Point3dP3P_2);
P2c=sum(Point3dP3P_2)/length(Point3dP3P_2);
W=zeros(3);
for i=1:length(P1)
    Wi=P1(i,:)'*P2(i,:);        %计算W矩阵
    W=W+Wi;
end
[U,~,V]=svd(W);                 %奇异值分解
R=U*V';                         %求解R
t=P1c'-R*P2c';                  %求解t
end

