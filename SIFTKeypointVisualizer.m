function image = SIFTKeypointVisualizer(Image, KeyPoints)
% This function creates an Image to visualize the SIFT features
% Input image should be gray scale.

    % Creating color image.
    image = cat(3, Image, Image, Image);
    for i=1:length(KeyPoints)
        [x, y] = KeyPoints{i}.coordinates();
        circle = [y,x,5];
        % adding circles to key point locations
        image = insertShape(image,'circle',circle,'LineWidth',1,'color',[255,0,0],'SmoothEdges',false);
    end
    for i=1:length(KeyPoints)
        [x, y] = KeyPoints{i}.coordinates();
        dir = KeyPoints{i}.direction();
        line = [y,x,y+10*sind(dir),x+10*cosd(dir)];
        % adding lines to key point locations
        image = insertShape(image,'line',line,'LineWidth',1,'color',[0,0,255]);
    end
    for i=1:6:length(KeyPoints)
        [x, y] = KeyPoints{i}.coordinates();
        % Distinguishing key point location with green dots
        image(x,y,:) = [0,255,0];
    end
end