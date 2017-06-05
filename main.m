clear;
clc;
original = imread('images/audreyhepburn.png');
image = rgb2gray(original);
output = cat(3, image, image, image);
image = double(image);
[keyPoints, image] = SIFT(image,3,5,1.6);
figure
imshow(image)