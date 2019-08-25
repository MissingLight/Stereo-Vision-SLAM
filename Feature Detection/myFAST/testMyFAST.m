clear
tic
solver = myFAST(imread('iii.png'));
time=toc
[corners] = solver.operate();
imshow('iii.png'); hold on;
for i = 1:length(corners)
plot(corners(i).x,corners(i).y,'.r');
end
title('MyFast')
