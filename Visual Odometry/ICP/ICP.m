function [R,t]=ICP(Point3ddepth_1,Point3dP3P_2)
%UNTITLED4 ICP�㷨������ֵ����ֽ�
%   ��������ֵ����ֽ����Rt��
%���ߣ��±��
P1=Point3ddepth_1-sum(Point3ddepth_1)/length(Point3ddepth_1);   %����ȥ��������
P1c=sum(Point3ddepth_1)/length(Point3ddepth_1);                 %������������
P2=Point3dP3P_2-sum(Point3dP3P_2)/length(Point3dP3P_2);
P2c=sum(Point3dP3P_2)/length(Point3dP3P_2);
W=zeros(3);
for i=1:length(P1)
    Wi=P1(i,:)'*P2(i,:);        %����W����
    W=W+Wi;
end
[U,~,V]=svd(W);                 %����ֵ�ֽ�
R=U*V';                         %���R
t=P1c'-R*P2c';                  %���t
end

