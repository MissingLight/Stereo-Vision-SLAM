clear
img = imread('img.png');
if ndims(img) == 3
    gray = rgb2gray(img);
else
    gray = img;
end
corners = detectFASTFeatures(gray,'MinContrast',0.1);
imshow(img); hold on;
plot(corners);

