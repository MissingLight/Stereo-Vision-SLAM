function [P,Z] = trajectory(Rt)
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
P=zeros(3,length(Rt)+1);
Z=zeros(3,length(Rt)+1);
Z(3,:)=10000;
for i=1:length(Rt)
    for j=i:-1:1
        P(:,i+1)=Rt(j).R*P(:,i+1)+Rt(j).t;
        Z(:,i+1)=Rt(j).R*Z(:,i+1)+Rt(j).t;
    end
end
end
