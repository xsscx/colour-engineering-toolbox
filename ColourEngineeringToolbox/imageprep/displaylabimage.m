function z=displaylabimage(data,size,degree_of_adaptation,illuminant)

% DISPLAYLABIMAGE: displays CIELAB data to screen
% data is CIELAB data in the form of three columns
% size is the dimensions in rows and columns of the image
%
% The data is converted to XYZ, by chromatic adaptation from
% source XYZ to D65 XYZ, and from there to sRGB for display
%
% DISPLAYLABIMAGE assumes the user is fully adapted to the display. A
% fractional degree of adaptation can be given in cases where adaptation is
% incomplete.
%
% Default illuminant for colorimetric computation of the measurement
% data is D50; if different from D50, enter the tristimulus values of the 
% required illuminant or use the function D.m to insert the appropriate values
%
% Example: displaylabimage(data,[2,2],0.7,D('A'));
%
%
%   Colour Engineering Toolbox
%   author:    Phil Green
%   version:   1.2
%   date:  	   29-07-2002
%   book:      https://www.wiley.com/en-us/Colour+Engineering%3A+Achieving+Device+Independent+Colour-p-9780470854136


if nargin>2
   deg=degree_of_adaptation;
else
   deg=0;
end

if nargin>3
   ill=illuminant;
else   
   ill=d(50);
end

XYZ=lab2xyz(data,ill);
XYZ2=bradford(XYZ,ill,d(65),deg);
srgb=xyz2srgb(XYZ2);
rgb=v2m(srgb,size)/255;
z=image(rgb);