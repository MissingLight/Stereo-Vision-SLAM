%软件功能：通过两组灰度图完成视觉里程计功能，即恢复相机运动轨迹和里程
%软件作者：陈斌豪
close all;
clear;
clc;
%% addpath files
addpath('featureMatching');
addpath('P3P');
addpath('ICP');
%% load data mat
load('camera.mat');     %读取相机参数
%% parameter setLeft='LeftCamera';
Right='RightCamera';    %数据集储存点
Left='LeftCamera';
%% loop
for picnum=1:143        %读取数据，逐帧处理
%% feature matching
    [Image1_l,Image1_r,Image2_l,Image2_r] = ReadPic(picnum,Left,Right);
    [m1_l,m2_l,m1_r,m2_r]=Featurematch(Image1_l, Image2_l, Image1_r, Image2_r);
    Point1_L=((m1_l.Location));
    Point1_R=((m1_r.Location));
    Point2_L=((m2_l.Location));
    Point2_R=((m2_r.Location));
    fprintf('%d has finished.\n',picnum);
%% calculate 3D coordinate
    Point3ddepth_1 = triangulate(Point1_L, Point1_R, P_L',P_R')*1000;     
    Point3ddepth_2 = triangulate(Point2_L, Point2_R, P_L',P_R')*1000;
%% data selection
length=length(Point1_L);
    Point1_L(fix(length/3)*3+1:end,:)=[];
    Point1_R(fix(length/3)*3+1:end,:)=[];
    Point2_L(fix(length/3)*3+1:end,:)=[];
    Point2_R(fix(length/3)*3+1:end,:)=[];
    Point3ddepth_1(fix(length/3)*3+1:end,:)=[];
    Point3ddepth_2(fix(length/3)*3+1:end,:)=[];
    clear length;
%% P3P 2D-3D
    [Point3dP3P_2,Point3ddepth_1]=P3P(Point2_L,Point3ddepth_1,P_L);
%% ICP 3D--Rt
    [R0,t0]=ICP(Point3ddepth_1,Point3dP3P_2);
    Rt(picnum).R=R0;
    Rt(picnum).t=t0;
end
%% trajectory
for i=1:(length(Rt))
    if norm(Rt(i).t)>=2000
        Rt(i).t=Rt(i).t/norm(Rt(i).t)*1300;
    end
end
% for i=1:length(Rt_tran)-2
%     Rt(i).R=Rt_tran{i+1}(1:3,1:3);
%     Rt(i).t=Rt_tran{i+1}(1:3,4)*1000;
% end
[Ptrajectory,Z]=trajectory(Rt);     %计算轨迹
mileage=zeros(1,length(Rt));
for i=1:(length(Ptrajectory)-1)
    mileage(:,i)=norm(Ptrajectory(:,i)-Ptrajectory(:,i+1));
end
V=mileage*10;
t=0:0.1:14.2;
figure(1000);
plot(t,V);
xlabel('t');
ylabel('V(mm/s)');
title('V-t')
Ptrajectory(2,:)=[];                %去除y轴数据
figure;
Z(2,:)=[];
h1=plot(Ptrajectory(1,:),Ptrajectory(2,:));
hold on;
plot(Z(1,:),Z(2,:),'bo');
for i=1:length(Z)
    plot([Ptrajectory(1,i) Z(1,i)],[Ptrajectory(2,i) Z(2,i)],'r');      %绘制相机姿态
end
hold off;
title('trajectory');
xlabel('x(mm)');
ylabel('z(mm)');
total_m=sum(mileage)                %显示里程
hold on;

%% show GPS_trajectory
load('t_true.mat');
h2=plot(t_true(2,:),t_true(1,:),'r','linewidth',2);
hold off;
legend([h1 h2],'视觉里程计恢复图像','GPS数据');