clear;
clc;
original = imread('images/sky.jpg');
image = rgb2gray(original);
output = cat(3, image, image, image);
image = double(image);
% Key point coordinated, orientation and magnitute
result = SIFT(image,3,5,1.6);
for i=1:4:length(result)
    % adding circles to key point locations
    output = insertShape(output,'circle',[result(i+1),result(i),5],'LineWidth',1,'color',[255,0,0],'SmoothEdges',false);
end
for i=1:4:length(result)
    % adding lines to key point locations
    output = insertShape(output,'line',[result(i+1),result(i),result(i+1)+10*sind(result(i+2)),result(i)+10*cosd(result(i+2))],'LineWidth',1,'color',[0,0,255]);
end
for i=1:4:length(result)
    % Distinguishing key point location with green dots
    output(result(i),result(i+1),:) = [0,255,0];
end
figure
imshow(uint8(output))