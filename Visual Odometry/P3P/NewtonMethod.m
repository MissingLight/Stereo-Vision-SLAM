function [X] = NewtonMethod(cosValue,LL,X0,TOL)
%UNTITLED3 牛顿迭代法算法
%   利用牛顿迭代法求解非线性方程组
%作者：陈斌豪
X0=X0';
w=LL(5);
v=LL(4);
cosab=cosValue(1);      %读取参数值
cosbc=cosValue(2);
cosac=cosValue(3);
f1=@(x,y) (1-w)*x^2-w*y^2-2*x*cosac+2*w*x*y*cosab+1;        %定义函数和雅可比矩阵
f2=@(x,y) (1-v)*y^2-v*x^2-2*y*cosbc+2*v*x*y*cosab+1;
j11=@(x,y) 2*(1-w)*x-2*cosac+2*w*y*cosab;
j12=@(x,y) -2*w*y+2*w*x*cosab;
j21=@(x,y) -2*v*x+2*v*y*cosab;
j22=@(x,y) 2*(1-v)*y-2*cosbc+2*v*x*cosab;
fx=[f1(X0(1),X0(2));f2(X0(1),X0(2))];
Jx=[j11(X0(1),X0(2)) j12(X0(1),X0(2));j21(X0(1),X0(2)) j22(X0(1),X0(2))];
d=-Jx\fx;
X=X0+d;
count=0;        %迭代过程
while abs(X-X0)>TOL
    X0=X;
    fx=[f1(X0(1),X0(2));f2(X0(1),X0(2))];
    Jx=[j11(X0(1),X0(2)) j12(X0(1),X0(2));j21(X0(1),X0(2)) j22(X0(1),X0(2))];
    d=-Jx\fx;
    X=X0+d;
    count=count+1;
    if count>=30        %迭代不收敛标记
        X=inf;
        break;
    end
end
X=X';
end

