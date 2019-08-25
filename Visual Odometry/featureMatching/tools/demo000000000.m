img_files1 = dir(strcat('image_l'));
img_files2 = dir(strcat('image_r'));
I1_l = imread([img_files1(3).folder, '/', img_files1(3).name]);
I1_r = imread([img_files2(3).folder, '/', img_files2(3).name]);
I2_l = imread([img_files1(4).folder, '/', img_files1(4).name]);
I2_r = imread([img_files2(4).folder, '/', img_files2(4).name]);
M=Featurematch(I1_l, I2_l, I1_r, I2_r);
