function P = SIFT(inputImage, Octaves, Scales, Sigma)
% This function is to extract sift features from a given image
    
    %% Setting Variables.
    OriginalImage = inputImage;
    Sigmas = sigmas(Octaves,Scales,Sigma);
    ContrastThreshhold = 7.68;
    rCurvature = 10;
    OrientationCalculationRadius = 10;
    G = cell(1,Octaves); % Gaussians
    D = cell(1,Octaves); % DoG
    P = []; % Key Points

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
        gaussians = cell2mat(G(o));
        [row,col,Scales] = size(images);
        for s=2:Scales-1
            for y=2:col-1
                for x=2:row-1
                    sub = images(x-1:x+1,y-1:y+1,s-1:s+1);
                    if sub(2,2,2) > max([sub(1:13),sub(15:end)]) || sub(2,2,2) < min([sub(1:13),sub(15:end)])
                        % Getting rid of bad Key Points
                        if abs(sub(2,2,2)) < ContrastThreshhold
                            % Low contrast.
                            continue
                        else
                            % Calculating trace and determinant of hessian
                            % matrix.
                            Dxx = sub(1,2,2)+sub(3,2,2)-2*sub(2,2,2);
                            Dyy = sub(2,1,2)+sub(2,3,2)-2*sub(2,2,2);
                            Dxy = sub(1,1,2)+sub(3,3,2)-2*sub(1,3,2)-2*sub(3,1,2);
                            trace = Dxx+Dyy;
                            determinant = Dxx*Dyy-Dxy*Dxy;
                            curvature = trace*trace/determinant;
                            if curvature > (rCurvature+1)^2/rCurvature
                                % Not a corner.
                                continue
                            end
                        end
                        %% Calculating orientation and magnitute of pixels at key point vicinity
                        % Weight for gradient vectors
                        weights = gaussianKernel(1.5*Sigmas(o,s));
                        radius = (length(weights)-1)/2;
                        [wRows,wCols] = size(weights);
                        % 36 bin histogram.
                        gHist = zeros(1,36);
                        for i = 1:wRows
                            for j = 1:wCols
                                % Converting orientation calculation window
                                % coordinate to image coordinate /
                                % translating coordinate
                                imageX = x-radius-1+i;
                                imageY = y-radius-1+j;
                                % Making sure index will not fall outside
                                % of Image
                                if imageX <= 1 || imageX >= row
                                    continue
                                end
                                if imageY <= 1 || imageY >= col
                                    continue
                                end
                                % Calculations and assigning bins
                                tempOrientation = atan3d(gaussians(imageX,imageY+1,s)-gaussians(imageX,imageY-1,s), gaussians(imageX+1,imageY,s)-gaussians(imageX-1,imageY,s));
                                tempMagnitute = ((gaussians(imageX+1,imageY,s)-gaussians(imageX-1,imageY,s))^2+(gaussians(imageX,imageY+1,s)-gaussians(imageX,imageY-1,s))^2)^0.5;
                                bin = floor(tempOrientation/10)+1;
                                gHist(bin) =+ tempMagnitute*weights(i,j);
                            end
                        end
                        %% Choosing keypoint
                        orientationThreshold = max(gHist(:))*4/5;
                        for i=1:length(gHist)
                            if gHist(i) > orientationThreshold
                                % TODO: Interpolation for X and Y value to get
                                % subpixel accuracy.
                                % TODO: Right now the center of bin is chosen as
                                % orientation, this can be inmroved by interpolation.
                                Px = x*2^(o-1); % x coordinate
                                Py = y*2^(o-1); % y coordinate
                                Po = i*10-5; % Center of bin
                                Pr = gHist(i); % Size scales by number of octave
                                P = [P,Px,Py,Po,Pr];
                            end
                        end
                    end
                end
            end
        end
    end
end

%% Function to extract Sigma values
function matrix = sigmas(octave,scale,sigma)
% Function to calculate Sigma values for different Gaussians
    matrix = zeros(octave,scale);
    k = sqrt(2);
    for i=1:octave
        for j=1:scale
            matrix(i,j) = i*k^(j-1)*sigma;
        end
    end
end

%% Calculating Arc Tan from 0 to 360
function v = atan3d(y,x)
% New Atan function to return orientation in between 0 to 360
% atan2d function will bring the result in between -180 and 180
    v=atan2d(y,x);
    if v < 0
        v = 360 + v;
    end
end

%% Calculating Gaussian value given SD
function result = gaussianKernel(SD, Radius)
% Returns a gaussian kernet
% By default a radius will be chosen to so kernel covers 99.7 % of data.
    if nargin < 2
        Radius = ceil(3*SD);
    end
    side = 2*Radius+1;
    result = zeros(side);
    for i = 1:side
        for j = 1:side
            x = i-(Radius+1);
            y = j-(Radius+1);
            result(i,j)=(x^2+y^2)^0.5;
        end
    end
    result = exp(-(result .^ 2) / (2 * SD * SD));
    result = result / sum(result(:));
end
