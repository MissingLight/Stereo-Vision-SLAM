function [Point3dP3P,Point3dP] = P3P(Point2d,Point3d,P_L)
%UNTITLED P3P算法
%   通过已知一组三维点坐标和一组像素坐标推算另一组三维坐标
%作者：陈斌豪
TOL=0.0001;             %读入相机参数
fx=P_L(1,1);
fy=P_L(2,2);
cx=P_L(1,3);
cy=P_L(2,3);
ax=(Point2d(:,1)-cx)/fx;    %计算方向向量
ay=(Point2d(:,2)-cy)/fy;
az=ones(size(ax));
Norm=sqrt(ax.^2+ay.^2+az.^2);
aNx=ax./Norm;
aNy=ay./Norm;
aNz=az./Norm;
cosValue=zeros(length(ax)/3,3);     
LL=zeros(length(ax)/3,6);
Point3dP=Point3d;
N=[aNx aNy aNz];
for i=1:(length(ax)/3)
    cosValue(i,1)=aNx(3*i-2)*aNx(3*i-1)+aNy(3*i-2)*aNy(3*i-1)+aNz(3*i-2)*aNz(3*i-1);        %计算余弦值
    cosValue(i,2)=aNx(3*i)*aNx(3*i-1)+aNy(3*i)*aNy(3*i-1)+aNz(3*i)*aNz(3*i-1);
    cosValue(i,3)=aNx(3*i-2)*aNx(3*i)+aNy(3*i-2)*aNy(3*i)+aNz(3*i-2)*aNz(3*i);
    LL(i,1)=sqrt((Point3d(3*i-2,1)-Point3d(3*i-1,1))^2+(Point3d(3*i-2,2)-Point3d(3*i-1,2))^2+(Point3d(3*i-2,3)-Point3d(3*i-1,3))^2);        %计算长度及长度比值
    LL(i,2)=sqrt((Point3d(3*i,1)-Point3d(3*i-1,1))^2+(Point3d(3*i,2)-Point3d(3*i-1,2))^2+(Point3d(3*i,3)-Point3d(3*i-1,3))^2);
    LL(i,3)=sqrt((Point3d(3*i-2,1)-Point3d(3*i,1))^2+(Point3d(3*i-2,2)-Point3d(3*i,2))^2+(Point3d(3*i-2,3)-Point3d(3*i,3))^2);
    LL(i,4)=LL(i,2)^2/LL(i,1)^2;
    LL(i,5)=LL(i,3)^2/LL(i,1)^2;
    LL(i,6)=sqrt(Point3d(3*i,1)^2+Point3d(3*i,2)^2+Point3d(3*i,3)^2);
end
X0=zeros(length(ax)/3,2);       %给定迭代初值
for i=1:(length(ax)/3)
    X0(i,1)=sqrt((Point3d(3*i-2,1)^2+Point3d(3*i-2,2)^2+Point3d(3*i-2,3)^2)/LL(i,6)^2);
    X0(i,2)=sqrt((Point3d(3*i-1,1)^2+Point3d(3*i-1,2)^2+Point3d(3*i-1,3)^2)/LL(i,6)^2);
end
X=zeros(length(ax)/3,2);
for i=1:(length(ax)/3)
    X(i,:)=NewtonMethod(cosValue(i,:),LL(i,:),X0(i,:),TOL);     %牛顿迭代法计算xy
end
count=1;
while 1         %剔除不收敛点
    if X(count,:)==inf
        X(count,:)=[];
        Point3dP(3*count-2:3*count,:)=[];
        LL(count,:)=[];
        N(3*count-2:3*count,:)=[];
        cosValue(count,:)=[];
    else
        count=count+1;
    end
    if count>length(X)
        break;
    end
end
L=zeros(length(X)*3,1);
for i=1:(length(X))         %计算长度
    L(3*i)=sqrt(LL(i,1)^2/(X(i,1)^2+X(i,2)^2-2*X(i,1)*X(i,2)*cosValue(i,1)));
    L(3*i-2)=X(i,1)*L(3*i);
    L(3*i-1)=X(i,2)*L(3*i);
end

for i=1:length(X)*3         %计算三维坐标
    Point3dP3P(i,:)=L(i)*N(i,:);
end
end

