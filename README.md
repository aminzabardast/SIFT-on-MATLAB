# SIFT-on-MATLAB
This is an implementation of if [Distinctive image features from scale-invariant keypoints](https://scholar.google.com/citations?view_op=view_citation&hl=en&user=8vs5HGYAAAAJ&citation_for_view=8vs5HGYAAAAJ:u_35RYKgDlwC) by [David Lowe](https://scholar.google.com/citations?user=8vs5HGYAAAAJ) for "Advanced Topics in Medical Image Analysis" course.
# Usage
Read an image in Matlab and convert it into gray scale image then use it as input for `SIFT` function.

Example:
```
image = imread('image.jpg');
image = double(rgb2gray(image));
keyPoints = SIFT(image,3,5,1.6);
```

Key points created in the process are objects. All of the key points are returned in a cell array. Each key point contains:

- `coordinates():`returns **[x, y]** coordinate of the key point on image.
- `direction():`Returns general Direction of the key point.
- `magnitude():`Returns the magnitude of general direction vector.
- `octave():`Returns number of the octave which the key point extracted from.
- `scale():` Returns sigma value which the image is convolved with.
- `descriptor():`Returns a vector containing the descriptor.
 
# Image Visualizer
This function's main purpose is to illustrate the keypoints on the image. The function `SIFTKeypointVisualizer` will be called after extracting keypoints.

Example:
```
image = SIFTKeypointVisualizer(image,keyPoints);
imshow(uint8(image));
```

# Disclaimer
All the rights to **"Distinctive image features from scale-invariant keypoints"** are reserved for **[University of British Columbia](http://www.cs.ubc.ca/~lowe/keypoints/)**. *A license must be obtained from the University of British Columbia for any commercial applications.*

# Contact
Contact following emails for further information.
[zabardast.amin@metu.edu.tr](mailto:zabardast.amin@metu.edu.tr)
[kilic.ozkan@metu.edu.tr](mailto:kilic.ozkan@metu.edu.tr)
