clear;
clc;
original = imread('images/audreyhepburn.png');
image = rgb2gray(original);
image = double(image);
result = SIFT(image,3,5,1.6);
for i=1:2:length(result)
    original(result(i),result(i+1),:) = [255,0,0];
end
figure
imshow(uint8(original))