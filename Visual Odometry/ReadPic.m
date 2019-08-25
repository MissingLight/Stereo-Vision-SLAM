function [Image1_l,Image1_r,Image2_l,Image2_r] = ReadPic(picnum,Left,Right)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
if picnum<=9
    Image1_l=imread(sprintf('%s/data/000000000%d.png',Left,picnum-1));
    Image1_r=imread(sprintf('%s/data/000000000%d.png',Right,picnum-1));
    Image2_l=imread(sprintf('%s/data/000000000%d.png',Left,picnum));
    Image2_r=imread(sprintf('%s/data/000000000%d.png',Right,picnum));
elseif picnum==10
    Image1_l=imread(sprintf('%s/data/0000000009.png',Left));
    Image1_r=imread(sprintf('%s/data/0000000009.png',Right));
    Image2_l=imread(sprintf('%s/data/0000000010.png',Left));
    Image2_r=imread(sprintf('%s/data/0000000010.png',Right));
elseif picnum<=99
    Image1_l=imread(sprintf('%s/data/00000000%d.png',Left,picnum-1));
    Image1_r=imread(sprintf('%s/data/00000000%d.png',Right,picnum-1));
    Image2_l=imread(sprintf('%s/data/00000000%d.png',Left,picnum));
    Image2_r=imread(sprintf('%s/data/00000000%d.png',Right,picnum));
elseif picnum==100
    Image1_l=imread(sprintf('%s/data/0000000099.png',Left));
    Image1_r=imread(sprintf('%s/data/0000000099.png',Right));
    Image2_l=imread(sprintf('%s/data/0000000100.png',Left));
    Image2_r=imread(sprintf('%s/data/0000000100.png',Right));
else
    Image1_l=imread(sprintf('%s/data/0000000%d.png',Left,picnum-1));
    Image1_r=imread(sprintf('%s/data/0000000%d.png',Right,picnum-1));
    Image2_l=imread(sprintf('%s/data/0000000%d.png',Left,picnum));
    Image2_r=imread(sprintf('%s/data/0000000%d.png',Right,picnum));
end
end

