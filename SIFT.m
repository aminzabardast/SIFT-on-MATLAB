function D = SIFT(inputImage)
% This function is to extract sift features from a given image
    
    %% Setting Variables.
    Octaves = 4;
    Scales = 5;
    Sigmas = sigmas(Octaves,Scales);
    G = cell(1,Octaves); % Gaussians
    D = cell(1,Octaves); % DoG
    P = cell(1,Octaves); % Key Points
    %% Calculating Gaussians
    for o=1:Octaves
        [row,col] = size(inputImage);
        temp = zeros([row,col,Scales]);
        for s=1:Scales
            temp(:,:,s) = imgaussfilt(inputImage,Sigmas(o,s));
        end
        G(o) = {temp};
        inputImage = inputImage(2:2:end,2:2:end);
    end
    %% Calculating DoG
    for o=1:Octaves
        images = cell2mat(G(o));
        [row,col,Scales] = size(images);
        temp = zeros([row,col,Scales-1]);
        for s=1:Scales-1
            temp(:,:,s) = images(:,:,s+1) - images(:,:,s);
        end
        D(o) = {temp};
    end
    %% Extracting Key Points
    for o=1:Octaves
        images = cell2mat(D(o));
        [row,col,Scales] = size(images);
        temp = zeros([row,col,Scales-2]);
        for s=2:Scales-1
            for y=2:col-1
                for x=2:row-1
                    sub = images(x-1:x+1,y-1:y+1,s-1:s+1);
                    if sub(2,2,2) > max([sub(1:13),sub(15:end)]) || sub(2,2,2) < min([sub(1:13),sub(15:end)])
                        temp(x,y,s-1) = 1;
                    end
                end
            end
        end
        P(o) = {temp};
    end
end

function matrix = sigmas(octave,scale)
% Function to calculate Sigma values for different Gaussians
    matrix = zeros(octave,scale);
    k = sqrt(2);
    Sigma = sqrt(2);
    for i=1:octave
        for j=1:scale
            matrix(i,j) = i*k^(j-1)*Sigma;
        end
    end
end