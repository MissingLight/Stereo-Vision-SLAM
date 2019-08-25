function [X] = NewtonMethod(cosValue,LL,X0,TOL)
%UNTITLED3 ţ�ٵ������㷨
%   ����ţ�ٵ������������Է�����
%���ߣ��±��
X0=X0';
w=LL(5);
v=LL(4);
cosab=cosValue(1);      %��ȡ����ֵ
cosbc=cosValue(2);
cosac=cosValue(3);
f1=@(x,y) (1-w)*x^2-w*y^2-2*x*cosac+2*w*x*y*cosab+1;        %���庯�����ſɱȾ���
f2=@(x,y) (1-v)*y^2-v*x^2-2*y*cosbc+2*v*x*y*cosab+1;
j11=@(x,y) 2*(1-w)*x-2*cosac+2*w*y*cosab;
j12=@(x,y) -2*w*y+2*w*x*cosab;
j21=@(x,y) -2*v*x+2*v*y*cosab;
j22=@(x,y) 2*(1-v)*y-2*cosbc+2*v*x*cosab;
fx=[f1(X0(1),X0(2));f2(X0(1),X0(2))];
Jx=[j11(X0(1),X0(2)) j12(X0(1),X0(2));j21(X0(1),X0(2)) j22(X0(1),X0(2))];
d=-Jx\fx;
X=X0+d;
count=0;        %��������
while abs(X-X0)>TOL
    X0=X;
    fx=[f1(X0(1),X0(2));f2(X0(1),X0(2))];
    Jx=[j11(X0(1),X0(2)) j12(X0(1),X0(2));j21(X0(1),X0(2)) j22(X0(1),X0(2))];
    d=-Jx\fx;
    X=X0+d;
    count=count+1;
    if count>=30        %�������������
        X=inf;
        break;
    end
end
X=X';
end

