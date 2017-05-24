function G = SIFT(inputImage)
% This function is to extract sift features from a given image
    
    %% Setting Variables.
    Octaves = 4;
    Scales = 5;
    Sigmas = sigmas(Octaves,Scales);
    G = cell(1,Octaves); % Gaussians
    %% Calculating Gaussians
    for i=1:Octaves
        [row,col] = size(inputImage);
        temp = zeros([row,col,Scales]);
        for j=1:Scales
            temp(:,:,j) = imgaussfilt(inputImage,Sigmas(i,j));
        end
        G(i) = {temp};
        inputImage = inputImage(2:2:end,2:2:end);
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