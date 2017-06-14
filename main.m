clear;
clc;
image = imread('images/audrydiff.jpg');
image = rgb2gray(image);
image = double(image);
keyPoints = SIFT(image,7,5,1.3);
image = SIFTKeypointVisualizer(image,keyPoints);
imwrite(uint8(image),'~/Desktop/ABC/ahdiff.png')