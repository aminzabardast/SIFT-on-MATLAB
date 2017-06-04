clear;
clc;
original = imread('images/audreyhepburn.png');
image = rgb2gray(original);
image = double(image);
% Key point coordinated, orientation and magnitute
result = SIFT(image,3,5,1.6);
for i=1:4:length(result)
    % adding circle and lines to key point locations
    original = insertShape(original,'circle',[result(i+1),result(i),result(i+3)],'LineWidth',1,'color',[255,0,0],'SmoothEdges',false);
    original = insertShape(original,'line'...
        ,[result(i+1),result(i),result(i+1)+result(i+3)*sin(result(i+2)),result(i)+result(i+3)*cos(result(i+2))],...
        'LineWidth',1,'color',[255,0,0]);
    original(result(i),result(i+1),:) = [0,255,0];
end
figure
imshow(uint8(original))